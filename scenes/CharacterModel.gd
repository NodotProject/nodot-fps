extends CharacterExtensionBase3D

@onready var anim: AnimationTree = $AnimationTree

var last_position: Vector3 = Vector3.ZERO
var target_movement_vector: Vector2 = Vector2.ZERO
var target_movement_velocity: float = 0.5

func ready():
	if !enabled:
		return
	
	character.connect("fall_damage", _on_fall_damage)
	register_handled_states(["jump", "land", "idle", "walk", "sprint", "crouch", "prone"])
	
	if character.is_current_player:
		var i = 0
		for child in Nodot.get_children_of_type($combined/RootNode/Skeleton3D, MeshInstance3D):
			if i < 6:
				child.transparency = 1.0
			i += 1
	
func state_updated(old_state: int, new_state: int) -> void:
	if new_state == state_ids["jump"]:
		anim["parameters/Jumping/blend_position"] = -1.0
	elif new_state == state_ids["sprint"]:
		target_movement_velocity = 1.0
	elif new_state == state_ids["walk"]:
		target_movement_velocity = 0.5

func physics(delta: float) -> void:
	if sm.state == state_ids["jump"] or !character._is_on_floor():
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 0.0, 0.1)
		anim["parameters/Jumping/blend_position"] = lerp(anim["parameters/Jumping/blend_position"], 0.0, 0.1)
	elif sm.state == state_ids["land"]:
		anim["parameters/Jumping/blend_position"] = lerp(anim["parameters/Jumping/blend_position"], 1.0, 0.3)
	elif sm.state == state_ids["crouch"]:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 1.0, 0.1)
	else:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], -1.0, 0.1)
		
		var movement_direction = last_position.direction_to(character.global_position)
		target_movement_vector = Vector2(movement_direction.x, -movement_direction.z) * target_movement_velocity
		anim["parameters/HolsteredMovement/blend_position"] = lerp(anim["parameters/HolsteredMovement/blend_position"], target_movement_vector, 0.1)
		last_position = character.global_position
		
		
func _on_fall_damage(_amount):
	anim["parameters/Hard Landing/request"] = true
