## A node to manage Prone movement of a NodotCharacter3D
class_name CharacterProne3D extends CharacterExtensionBase3D

## The collision shape to shrink when proned
@export var collision_shape: CollisionShape3D
## The new height of the collision shape
@export var prone_height: float = 0.1
## The new movement speed
@export var movement_speed: float = 0.5

@export_category("State Handlers")
## Set the idle state handler
@export var idle_state_handler: StateHandler

@export_subgroup("Input Actions")
## The input action name for proning
@export var prone_action: String = "prone"

var head: Node3D
var initial_movement_speed: float = 5.0
var initial_head_position: Vector3
var target_head_position: Vector3
var collider_height: float = 0.0

func setup():
	InputManager.register_action(prone_action, KEY_X)
	
	if collision_shape and collision_shape.shape and collision_shape.shape is CapsuleShape3D:
		collider_height = collision_shape.shape.height
		
	initial_movement_speed = character.movement_speed
	
	head = character.get_node("Head")
	initial_head_position = head.position
	
func enter(_old_state) -> void:
	collision_shape.rotation.x = PI / 2
	target_head_position = Vector3(head.position.x, 0.0, -(collider_height / 2))
	character.velocity = Vector3.ZERO
	character.movement_speed = movement_speed
		
func exit(_old_state) -> void:
	collision_shape.rotation.x = 0.0
	character.movement_speed = initial_movement_speed
	head.position = initial_head_position

func input(event: InputEvent) -> void:
	if Input.is_action_pressed(prone_action):
		state_machine.set_state(name)
	elif Input.is_action_just_released(prone_action):
		state_machine.set_state(idle_state_handler.name)

func physics(_delta):
	head.position = lerp(head.position, target_head_position, 0.1)
