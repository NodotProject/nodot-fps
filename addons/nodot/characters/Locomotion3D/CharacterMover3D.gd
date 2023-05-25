## A node to manage WASD and Jump movement of a NodotCharacter3D
class_name CharacterMover3D extends CharacterExtensionBase3D

## Gravity for the character
@export var gravity: float = 12.0
## Friction when stopping. The smaller the value, the more you slide (-1 to disable)
@export var friction: float = 1.0
## Enables stepping up stairs.
@export var stepping_enabled: bool = true
## Maximum height for a ledge to allow stepping up.
@export var step_height: float = 1.0
## Constructs the step up movement vector.
@onready var step_vector: Vector3 = Vector3(0, step_height, 0)
## How high the character can jump
@export var jump_velocity := 4.5
## How fast the character can move
@export var movement_speed := 5.0
## How fast the character can move while sprinting (higher = faster)
@export var sprint_speed_multiplier := 2.0
## The maximum speed a character can fall
@export var terminal_velocity := 190.0

var input_direction_source
var sprint_speed = false

func _ready():
	if !enabled:
		return
		
	if character.keyboard_input:
		input_direction_source = character.keyboard_input
		
	register_handled_states(["idle", "walk", "jump", "sprint", "crouch", "prone", "land", "sneak", "crawl"])
		
	sm.add_valid_transition("idle", ["crouch", "prone"])
	sm.add_valid_transition("land", ["crouch", "prone"])
	sm.add_valid_transition("sprint", ["crouch", "prone"])
	sm.add_valid_transition("crouch", ["idle", "sneak", "jump", "prone"])
	sm.add_valid_transition("prone", ["idle", "crawl", "jump", "crouch"])
	sm.set_state(state_ids["idle"])
	
func state_updated(old_state: int, new_state: int) -> void:
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

func action(delta: float) -> void:
	if !character._is_on_floor() or character.velocity.y > 0:
		move_air(delta)
	else:
		move_ground(delta)

func move_air(delta: float) -> void:
	character.velocity.y = min(terminal_velocity, character.velocity.y - gravity * delta)
	
	var final_speed = get_movement_speed(delta)
	if input_direction_source.direction != Vector3.ZERO:
		character.velocity.x = lerp(character.velocity.x, input_direction_source.direction.x * final_speed, 0.025)
		character.velocity.z = lerp(character.velocity.z, input_direction_source.direction.z * final_speed, 0.025)
	
	character.move_and_slide()

func move_ground(delta: float) -> void:
	var character_state = sm.state
	
	if character_state == state_ids["jump"]:
		sm.set_state(state_ids["land"])
	
	if not [state_ids["walk"], state_ids["sprint"], state_ids["idle"]].has(character_state):
		return
	
	var final_speed = get_movement_speed(delta)
		
	if input_direction_source.direction == Vector3.ZERO:
		var final_friction = friction if friction >= 0 else final_speed
		character.velocity.x = move_toward(character.velocity.x, 0, friction)
		character.velocity.z = move_toward(character.velocity.z, 0, friction)
	else:
		character.velocity.x = input_direction_source.direction.x * final_speed
		character.velocity.z = input_direction_source.direction.z * final_speed
	
	# --- Stairs logic ---
	var starting_position: Vector3 = character.global_position
	var starting_velocity: Vector3 = character.velocity
	
	# Start by moving our character body by its normal velocity.
	character.move_and_slide()
	if !stepping_enabled or !character._is_on_floor(): return
	
	# Next, we store the resulting position for later, and reset our character's
	#    position and velocity values.
	var slide_position: Vector3 = character.global_position
	character.global_position = starting_position
	character.velocity = Vector3(starting_velocity.x, 0.0, starting_velocity.z)
	
	# After that, we move_and_collide() them up by step_height, move_and_slide()
	#    and move_and_collide() back down
	character.move_and_collide(step_vector)
	character.move_and_slide()
	character.move_and_collide(-step_vector)
	
	# Finally, we test move down to see if they'll touch the floor once we move
	#    them back down to their starting Y-position, if not, they fall,
	#    otherwise, they step down by -step_height.
	if !character.test_move(character.global_transform, -step_vector):
		character.move_and_collide(-step_vector)
		
	# Now that we've done all that, we get the distance moved for both movements
	#    and go with whichever one moves us further, as overhangs could impede 
	#    movement if we were to only step.
	var slide_distance: float = starting_position.distance_to(slide_position)
	var step_distance: float = starting_position.distance_to(character.global_position)
	if slide_distance > step_distance or !character._is_on_floor():
		character.global_position = slide_position
	# --- Step up logic ---

func jump() -> void:
	character.velocity.y = jump_velocity
