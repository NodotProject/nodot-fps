## A node to manage Jump movement of a NodotCharacter3D
class_name CharacterJump3D extends CharacterExtensionBase3D

## How high the character can jump
@export var jump_velocity := 4.5

func _ready():
	if !enabled:
		return
		
	register_handled_states(["idle", "walk", "jump", "sprint", "crouch", "prone", "land", "sneak", "crawl"])
		
	sm.add_valid_transition("idle", ["crouch", "prone"])
	sm.add_valid_transition("land", ["crouch", "prone"])
	sm.add_valid_transition("sprint", ["crouch", "prone"])
	sm.add_valid_transition("crouch", ["idle", "sneak", "jump", "prone"])
	sm.add_valid_transition("prone", ["idle", "crawl", "jump", "crouch"])
	sm.set_state(state_ids["idle"])

func state_updated(old_state: int, new_state: int) -> void:	
	if new_state == state_ids["jump"]:
		jump()

func jump() -> void:
	character.velocity.y = jump_velocity
