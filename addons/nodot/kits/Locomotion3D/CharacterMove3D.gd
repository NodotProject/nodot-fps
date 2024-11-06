## A node to manage WASD of a NodotCharacter3D
class_name CharacterMove3D extends CharacterExtensionBase3D

## How fast the character can move while sprinting (higher = faster)
@export var sprint_speed_multiplier := 2.0

@export_subgroup("Input Actions")
## The input action name for sprinting
@export var sprint_action: String = "sprint"

var original_speed: float = 0.0

func setup():
	original_speed = character.movement_speed
	InputManager.register_action(sprint_action, KEY_SHIFT)

func physics(delta: float):
	var final_speed: float = original_speed
	if character.input_enabled and character.direction3d != Vector3.ZERO:
		if Input.is_action_pressed(sprint_action):
			final_speed = original_speed * sprint_speed_multiplier
		
	character.movement_speed = final_speed * delta * 100
