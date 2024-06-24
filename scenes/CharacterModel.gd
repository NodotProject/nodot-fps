extends CharacterExtensionBase3D

@onready var anim: AnimationTree = $AnimationTree

var last_position: Vector3 = Vector3.ZERO
var target_movement_vector: Vector2 = Vector2.ZERO
var target_movement_velocity: float = 0.5

func ready():
	if !enabled:
		return
	
	character.connect("fall_damage", _on_fall_damage)
	character.connect("current_camera_changed", _on_camera_change)
	register_handled_states(["jump", "land", "idle", "walk", "sprint", "crouch", "prone"])
	
	if character.is_current_player:
		toggle_model(false)
	
func state_updated(_old_state: int, new_state: int) -> void:
	if new_state == state_ids["jump"]:
		anim["parameters/Jumping/blend_position"] = -1.0
	elif new_state == state_ids["land"]:
		anim["parameters/Jumping/blend_position"] = 1.0
	elif new_state == state_ids["sprint"]:
		target_movement_velocity = 1.0
	elif new_state == state_ids["walk"]:
		target_movement_velocity = 0.5

func physics(_delta: float) -> void:
	if sm.state == state_ids["crouch"]:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 1.0, 0.1)
		if Vector2(character.velocity.x, character.velocity.z) == Vector2.ZERO:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], 0.0, 0.3)
		else:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], 1.0, 0.3)
	elif sm.state == state_ids["prone"]:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 1.0, 0.1)
		if Vector2(character.velocity.x, character.velocity.z) == Vector2.ZERO:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], -1.0, 0.3)
		else:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], -1.0, 0.3)
	elif sm.state == state_ids["jump"] or !character.was_on_floor:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], -1.0, 0.1)
		anim["parameters/Jumping/blend_position"] = lerp(anim["parameters/Jumping/blend_position"], 0.0, 0.1)
	else:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 0.0, 0.05)
		
		var movement_direction = last_position.direction_to(character.global_position).rotated(Vector3.DOWN, character.rotation.y)
		target_movement_vector = Vector2(movement_direction.x, -movement_direction.z) * target_movement_velocity
		anim["parameters/HolsteredMovement/blend_position"] = lerp(anim["parameters/HolsteredMovement/blend_position"], target_movement_vector, 0.1)
		last_position = character.global_position
		
		
func _on_fall_damage(_amount):
	anim["parameters/Hard Landing/request"] = true
	
func _on_camera_change(_old_camera: Camera3D, new_camera: Camera3D):
	if new_camera == character.camera:
		toggle_model(false)
	else:
		toggle_model(true)

func toggle_model(show_model: bool):
	var i = 0
	for child in Nodot.get_children_of_type($combined/RootNode/Skeleton3D, MeshInstance3D):
		if i < 6:
			if show_model:
				child.transparency = 0.0
			else:
				child.transparency = 1.0
		i += 1
