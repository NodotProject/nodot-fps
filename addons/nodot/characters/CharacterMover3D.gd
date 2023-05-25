# A node to manage WASD and Jump movement of a NodotCharacter3D
class_name CharacterMover3D extends Nodot

# Enable/disable this node.
@export var enabled : bool = true
## Gravity for the character
@export var gravity : float = 12.0
# Enables stepping up stairs.
@export var stepping_enabled : bool = true
# Maximum height for a ledge to allow stepping up.
@export var step_height : float = 1.0
# Constructs the step up movement vector.
@onready var step_vector : Vector3 = Vector3(0, step_height, 0)
## How high the character can jump
@export var jump_velocity := 4.5
## How fast the character can move
@export var movement_speed := 5.0
## How fast the character can move while sprinting (higher = faster)
@export var sprint_speed_multiplier := 2.0
## The maximum speed a character can fall
@export var terminal_velocity := 190.0

var parent : NodotCharacter3D
var handle_states: Array[int] = []
var state_ids: Dictionary = {}
var input_direction_source
var sprint_speed = false
var parent_statemachine: StateMachine

func _ready():
	parent = get_parent()
	if parent is NodotCharacter3D:
		parent_statemachine = parent.sm
	else:
		enabled = false
		return
		
	if parent.keyboard_input:
		input_direction_source = parent.keyboard_input
		
	_setup_valid_transitions()
	parent_statemachine.connect("state_updated", _on_character_state_updated)
		

func _setup_valid_transitions() -> void:
	for state_name in ["idle", "walk", "jump", "sprint", "crouch", "prone", "land", "sneak", "crawl"]:
		var state_id = parent_statemachine.register_state(state_name)
		state_ids[state_name] = state_id
		handle_states.append(state_id)
		
	parent_statemachine.add_valid_transition("idle", ["crouch", "prone"])
	parent_statemachine.add_valid_transition("land", ["crouch", "prone"])
	parent_statemachine.add_valid_transition("sprint", ["crouch", "prone"])
	parent_statemachine.add_valid_transition("crouch", ["idle", "sneak", "jump", "prone"])
	parent_statemachine.add_valid_transition("prone", ["idle", "crawl", "jump", "crouch"])
	parent_statemachine.set_state(state_ids["idle"])
	
func _physics_process(delta):
	var current_state = parent_statemachine.state
	if current_state < 0 or !handle_states.has(current_state):
		return
	move(delta)
	
func _on_character_state_updated(old_state: int, new_state: int) -> void:
	var sprint_id = state_ids["sprint"]
	
	if new_state == state_ids["jump"]:
		if old_state == sprint_id:
			sprint_speed = true
		jump()
	elif new_state == state_ids["land"] or old_state == sprint_id:
		sprint_speed = false
	elif new_state == sprint_id:
		sprint_speed = true
		
func get_movement_speed(delta: float) -> float:
	var final_speed = movement_speed
	if sprint_speed:
		final_speed = movement_speed * sprint_speed_multiplier
	return final_speed * delta * 100

func move(delta: float) -> void:
	if !parent._is_on_floor() or parent.velocity.y > 0:
		move_air(delta)
	else:
		move_ground(delta)

func move_air(delta: float) -> void:
	if !enabled: return
	parent.velocity.y = min(terminal_velocity, parent.velocity.y - gravity * delta)
	
	var final_speed = get_movement_speed(delta)
	if input_direction_source.direction != Vector3.ZERO:
		parent.velocity.x = lerp(parent.velocity.x, input_direction_source.direction.x * final_speed, 0.025)
		parent.velocity.z = lerp(parent.velocity.z, input_direction_source.direction.z * final_speed, 0.025)
	
	parent.move_and_slide()

func move_ground(delta: float) -> void:
	
	var character_state = parent_statemachine.state
	
	if character_state == state_ids["jump"]:
		parent_statemachine.set_state(state_ids["land"])
	
	if not [state_ids["walk"], state_ids["sprint"], state_ids["idle"]].has(character_state):
		return
	
	var final_speed = get_movement_speed(delta)
		
	if input_direction_source.direction == Vector3.ZERO:
		parent.velocity.x = move_toward(parent.velocity.x, 0, final_speed)
		parent.velocity.z = move_toward(parent.velocity.z, 0, final_speed)
	else:
		parent.velocity.x = input_direction_source.direction.x * final_speed
		parent.velocity.z = input_direction_source.direction.z * final_speed
	
	## Step up logic
	var starting_position : Vector3 = parent.global_position
	var starting_velocity : Vector3 = parent.velocity
	
	# Start by moving our character body by its normal velocity.
	parent.move_and_slide()
	if !stepping_enabled or !parent._is_on_floor(): return
	
	# Next, we store the resulting position for later, and reset our character's
	#    position and velocity values.
	var slide_position : Vector3 = parent.global_position
	parent.global_position = starting_position
	parent.velocity = Vector3(starting_velocity.x,0.0,starting_velocity.z)
	# After that, we move_and_collide() them up by step_height, move_and_slide()
	#    and move_and_collide() back down
	parent.move_and_collide(step_vector)
	parent.move_and_slide()
	parent.move_and_collide(-step_vector)
	# Finally, we test move down to see if they'll touch the floor once we move
	#    them back down to their starting Y-position, if not, they fall,
	#    otherwise, they step down by -step_height.
	if !parent.test_move(parent.global_transform,-step_vector):
		parent.move_and_collide(-step_vector)
	# Now that we've done all that, we get the distance moved for both movements
	#    and go with whichever one moves us further, as overhangs could impede 
	#    movement if we were to only step.
	var slide_distance : float = starting_position.distance_to(slide_position)
	var step_distance : float = starting_position.distance_to(parent.global_position)
	if slide_distance > step_distance or !parent._is_on_floor():
		parent.global_position = slide_position

func jump() -> void:
	if !enabled: return
	
	parent.velocity.y = jump_velocity
