extends Node

@export var jump_state_handler: CharacterJump3D
@export var move_state_handler: CharacterMove3D
@export var crouch_state_handler: CharacterCrouch3D
@export var prone_state_handler: CharacterProne3D

@onready var character: FirstPersonCharacter = get_parent()
@onready var anim: AnimationTree = $AnimationTree

var state_machine: StateMachine
var last_position: Vector3 = Vector3.ZERO
var target_movement_vector: Vector2 = Vector2.ZERO
var target_movement_velocity: float = 0.5

func _ready():
	character.connect("fall_damage", _on_fall_damage)
	character.connect("current_camera_changed", _on_camera_change)
	
	if character.is_current_player:
		toggle_model(false)
	
	state_machine = character.sm
	state_machine.on_state_changed.connect(_on_state_change)
	
func _on_state_change(old_state: StateHandler, new_state: StateHandler) -> void:
	if new_state is CharacterJump3D:
		anim["parameters/Jumping/blend_position"] = -1.0
	if new_state is CharacterMove3D:
		if move_state_handler.sprint_enabled:
			target_movement_velocity = 1.0
		else:
			target_movement_velocity = 0.5
	
	if old_state is CharacterJump3D:
		anim["parameters/Jumping/blend_position"] = 1.0

func _physics_process(delta: float) -> void:
	if state_machine._state_object is CharacterCrouch3D:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 1.0, 0.1)
		if Vector2(character.velocity.x, character.velocity.z) == Vector2.ZERO:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], 0.0, 0.3)
		else:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], 1.0, 0.3)
	elif state_machine._state_object is CharacterProne3D:
		anim["parameters/Blend/blend_amount"] = lerp(anim["parameters/Blend/blend_amount"], 1.0, 0.1)
		if Vector2(character.velocity.x, character.velocity.z) == Vector2.ZERO:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], -1.0, 0.3)
		else:
			anim["parameters/Crouching/blend_position"] = lerp(anim["parameters/Crouching/blend_position"], -1.0, 0.3)
	elif state_machine._state_object is CharacterJump3D:
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
