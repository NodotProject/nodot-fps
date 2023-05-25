# A base node to add extension logic to NodotCharacter3D
class_name CharacterExtensionBase3D extends Nodot

## Enable/disable this node.
@export var enabled : bool = true
## The NodotCharacter3D to apply this node to
@export var character: NodotCharacter3D
## Run action even when the state is unhandled
@export var action_unhandled_states: bool = false

var sm: StateMachine
var handled_states: Array[String] = []
var state_ids: Dictionary = {}

func _enter_tree():
	if not character:
		var parent = get_parent()
		if parent is NodotCharacter3D:
			character = parent
		else:
			enabled = false
			return
	
	sm = character.sm
	sm.connect("state_updated", state_updated)
	
func _physics_process(delta):
	if !enabled or !sm or sm.state < 0:
		return
	if !action_unhandled_states and !handles_state(sm.state):
		return
		
	action(delta)

## Registers a set of states that the node handles
func register_handled_states(new_states: Array[String]):
	for state_name in new_states:
		var state_id = sm.register_state(state_name)
		state_ids[state_name] = state_id
		handled_states.append(state_name)

## Checks whether this node handles a certain state
func handles_state(state: Variant) -> bool:
	if state is String:
		return handled_states.has(state)
	if state is int:
		return state_ids.values().has(state)
	return false

## Extend this placeholder. This is where your logic will be run every physics frame.
func action(delta: float) -> void:
	pass

## Extend this placeholder. This is triggered whenever the character state is updated.
func state_updated(old_state: int, new_state: int) -> void:
	pass
