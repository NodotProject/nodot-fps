## A node to manage Flying movement of a NodotCharacter3D
class_name CharacterFly3D extends CharacterExtensionBase3D

## The associated character mover
@export var character_mover: CharacterMover3D
## The new movement speed
@export var movement_speed: float = 5.0
## Effects how fast it takes to reach the movement speed
@export var acceleration: float = 10.0

@export_subgroup("Input Actions")
## The input action name for descending
@export var descend_action: String = "crouch"
## The input action name for ascending
@export var ascend_action: String = "jump"

var initial_gravity: float = 9.8
var initial_speed: float = 5.0
var sprint_multiplier: float = 2.0

func ready():
	if !enabled:
		return
	
	InputManager.register_action(descend_action, KEY_CTRL)
	InputManager.register_action(ascend_action, KEY_SPACE)
	
	register_handled_states(["jump", "fly", "land"])
	
	sm.add_valid_transition("fly", "land")
	sm.add_valid_transition("land", "idle")
	sm.add_valid_transition("jump", "fly")
		
	if character_mover:
		initial_gravity = character_mover.gravity
		initial_speed = character_mover.movement_speed
		sprint_multiplier = character_mover.sprint_speed_multiplier

func state_updated(old_state: int, new_state: int) -> void:
	if new_state == state_ids["fly"]:
		character_mover.gravity = 0.0
	elif new_state == state_ids["land"]:
		character_mover.gravity = initial_gravity

func physics(delta: float) -> void:
	var is_on_floor = character.is_on_floor()
	if !is_on_floor and Input.is_action_just_released(ascend_action):
		if sm.state == state_ids["jump"]:
			sm.set_state(state_ids["fly"])
			
	if sm.state == state_ids["land"]:
		sm.set_state(state_ids["idle"])
			
	if sm.state == state_ids["fly"]:
		if is_on_floor:
			sm.set_state(state_ids["land"])
		
		if Input.is_action_pressed(descend_action):
			character.velocity.y = -movement_speed
		if Input.is_action_pressed(ascend_action):
			character.velocity.y = movement_speed
		if Input.is_action_pressed(character_mover.up_action):
			character.velocity.z = movement_speed
		if Input.is_action_pressed(character_mover.down_action):
			character.velocity.z = -movement_speed
		if Input.is_action_pressed(character_mover.left_action):
			character.velocity.x = movement_speed
		if Input.is_action_pressed(character_mover.right_action):
			character.velocity.x = -movement_speed
	
	character.velocity = lerp(character.velocity, Vector3.ZERO, acceleration * delta)
	character.move_and_slide()
