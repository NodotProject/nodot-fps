## A node to manage Climb movement of a NodotCharacter3D
class_name CharacterClimb3D extends CharacterExtensionBase3D

## How high the character can climb
@export var climb_velocity := 4.0

@export_subgroup("Input Actions")
## The input action name for climbing
@export var climb_action: String = "up"
## The input action name for descending
@export var descend_action: String = "down"
## The input action name for jumping off the ladder
@export var jump_action: String = "jump"

var was_on_floor: bool = true

func ready():
	if !enabled:
		return

	InputManager.register_action(climb_action, KEY_W)
	InputManager.register_action(descend_action, KEY_S)

	handled_states = ["idle", "walk", "sprint", "jump", "climb"]

func can_enter() -> bool:
	return ["idle", "walk", "sprint", "jump", "climb"].has(sm.old_state)
	
func enter():
	if sm.state == &"climb":
		was_on_floor = true
		

func physics(delta: float):
	if !enabled:
		return

	if sm.state == &"climb":
		var ascend_velocity = climb_velocity
		var descend_velocity = -climb_velocity
		
		if character:
			var view_angle = character.head.rotation.x
			if view_angle < 0.0:
				ascend_velocity = -climb_velocity
				descend_velocity = climb_velocity
		
		if Input.is_action_pressed(climb_action):
			character.velocity.y = ascend_velocity
		elif Input.is_action_pressed(descend_action):
			character.velocity.y = descend_velocity
		elif Input.is_action_pressed(jump_action):
			sm.set_state(&"idle")
			sm.set_state(&"jump")
		else:
			character.velocity.y = 0.0
				
		character.velocity.x = lerp(character.velocity.x, 0.0, delta * 10.0)
		character.velocity.z = lerp(character.velocity.z, 0.0, delta * 10.0)
	
		var is_on_floor = character._is_on_floor()
		if is_on_floor and was_on_floor == false:
			sm.set_state(&"idle")
		
		was_on_floor = is_on_floor != null
			
		character.move_and_slide()
