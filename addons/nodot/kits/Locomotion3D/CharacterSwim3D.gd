@tool
## Assists with character water submersion controls and effects
class_name CharacterSwim3D extends CharacterExtensionBase3D

## The gravity to apply to the character while submerged
@export var submerged_gravity: float = 0.3
## How slow the character can move while underwater
@export var submerge_speed := 1.0
## The depth to allow before setting the character to swim
@export var submerge_offset := 1.0
## Detect changing water heights (more performance intensive)
@export var water_height_change_detection := false

@export_subgroup("Third Person Controls")
## Turn rate. If strafing is disabled, define how fast the character will turn.
@export var turn_rate: float = 0.1

@export_category("Input Actions")
## The input action name for swimming upwards
@export var ascend_action: String = "submerge_ascend"
## The input action name for swimming downwards
@export var descend_action: String = "submerge_descend"

## Triggered when submerged underwater
signal submerged
## Triggered when out of water
signal surfaced
## Triggered when the head is submerged
signal head_submerged
## Triggered when the head is surfaced
signal head_surfaced

var original_gravity: float
var submerged_water_area: WaterArea3D
var is_submerged: bool = false
var is_head_submerged: bool = false
var water_y_position: float = 0.0
var idle_state_handler: CharacterIdle3D
var third_person_camera_container: Node3D

func setup():
	var action_names = [ascend_action, descend_action]
	var default_keys = [KEY_SPACE, KEY_CTRL]
	for i in action_names.size():
		var action_name = action_names[i]
		InputManager.register_action(action_name, default_keys[i])
		
	var joy_default_keys = [JOY_BUTTON_A, JOY_BUTTON_B]
	for i in action_names.size():
		var action_name = action_names[i]
		InputManager.register_action(action_name, joy_default_keys[i], 2)
		
	original_gravity = character.gravity

func _physics_process(delta: float) -> void:
	if !is_submerged: return
	
	check_head_submerged()
	
func physics(delta: float) -> void:
	if !is_submerged: return
	
	var character_offset_position = character.global_position.y + submerge_offset
	
	swim(delta)
	
	if character_offset_position < water_y_position:
		state_machine.transition(idle_state_handler.name)
		
## Handles swimming movementw
func swim(delta: float) -> void:
	if !character.input_enabled:
		return
	
	var new_y_velocity = clamp(character.velocity.y - submerged_gravity * delta, -3.0, 3.0)
	character.velocity.y = lerp(character.velocity.y, new_y_velocity, 0.025)
	var ascend_pressed: bool = Input.is_action_pressed(ascend_action)
	var descend_pressed: bool = Input.is_action_pressed(descend_action)
	if ascend_pressed:
		if is_head_submerged:
			character.velocity.y = lerp(character.velocity.y, submerge_speed, delta)
		else:
			character.velocity.y = lerp(character.velocity.y, submerge_speed * 7, delta)
	elif descend_pressed:
		character.velocity.y = lerp(character.velocity.y, -submerge_speed, delta)

## Trigger submerge states
func set_submerged(input_submerged: bool, water_area: WaterArea3D) -> void:
	water_y_position = water_area.water_mesh_instance.global_position.y
	submerged_water_area = water_area
	is_submerged = input_submerged

	if is_submerged:
		state_machine.transition(name)
		submerged.emit()
	else:
		is_head_submerged = false
		submerged_water_area.revert()
		head_surfaced.emit()
		state_machine.transition(idle_state_handler.name)
		surfaced.emit()

## Check if the head (camera) is submerged
func check_head_submerged() -> void:
	var final_water_y_position: float = water_y_position
	
	if water_height_change_detection and submerged_water_area:
		final_water_y_position = submerged_water_area.water_mesh_instance.global_position.y + 0.15
		
	if !is_head_submerged and character.camera.global_position.y < final_water_y_position:
		is_head_submerged = true
		submerged_water_area.invert()
		head_submerged.emit()
	elif is_head_submerged and character.camera.global_position.y >= final_water_y_position:
		is_head_submerged = false
		submerged_water_area.revert()
		head_surfaced.emit()
