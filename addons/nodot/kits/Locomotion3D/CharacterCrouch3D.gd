## A node to manage Crouch movement of a NodotCharacter3D
class_name CharacterCrouch3D extends CharacterExtensionBase3D

## The collision shape to shrink when crouched
@export var collision_shape: CollisionShape3D
## The new height of the collision shape
@export var crouch_height: float = 1.0
## The associated character mover
@export var character_mover: CharacterMover3D
## The new movement speed
@export var movement_speed: float = 1.0

@export_subgroup("Input Actions")
## The input action name for crouching
@export var crouch_action: String = "crouch"

var shape_initial_height: float
var initial_movement_speed: float = 5.0


func ready():
	if !enabled:
		return

	InputManager.register_action(crouch_action, KEY_CTRL)

	handled_states = [&"crouch", &"stand", &"walk"]

	shape_initial_height = get_collision_shape_height()

	if character_mover:
		initial_movement_speed = character_mover.movement_speed

func can_enter() -> bool:
	return [&"idle", &"walk", &"sprint", &"crouch"].has(sm.old_state)

func enter() -> void:
	if not is_authority(): return
	
	if sm.state == &"crouch":
		apply_collision_shape_height(crouch_height)
		if character_mover:
			character_mover.movement_speed = movement_speed
	elif sm.state == &"stand":
		apply_collision_shape_height(shape_initial_height)
		if character_mover:
			character_mover.movement_speed = initial_movement_speed
		sm.set_state(&"idle")
		
func exit() -> void:
	apply_collision_shape_height(shape_initial_height)
	if character_mover:
		character_mover.movement_speed = initial_movement_speed

func input(_event):
	if Input.is_action_pressed(crouch_action):
		sm.set_state(&"crouch")
	elif Input.is_action_just_released(crouch_action):
		sm.set_state(&"stand")
		
func apply_collision_shape_height(crouch_height: float):
	if collision_shape and collision_shape.shape:
		if collision_shape.shape is CapsuleShape3D:
			collision_shape.shape.height = crouch_height
		elif collision_shape.shape is BoxShape3D:
			collision_shape.shape.size.y = crouch_height


func get_collision_shape_height() -> float:
	if collision_shape and collision_shape.shape:
		if collision_shape.shape is CapsuleShape3D:
			return collision_shape.shape.height
		elif collision_shape.shape is BoxShape3D:
			return collision_shape.shape.size.y
	return 0.0
