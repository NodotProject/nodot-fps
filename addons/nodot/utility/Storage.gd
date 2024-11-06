@icon("../icons/storage.svg")
## Redis-like class to store key-value pairs
class_name Storage extends Nodot

## Dictionary to store key-value pairs
@export var data: Dictionary = {}

var signals: Object

signal value_changed(key, new_value)
signal key_deleted(key)

## Method to set a value for a given key
func set_item(key: Variant, value: Variant):
	data[key] = value
	value_changed.emit(key, value)
	trigger_signal(key, value)

## Method to get the value for a given key
func get_item(key: Variant):
	return data.get(key)

## Method to check if a key exists
func has_item(key: Variant):
	return data.has(key)

## Method to delete a key-value pair
func delete_item(key: Variant):
	if has_item(key):
		var value = data[key]
		data.erase(key)
		key_deleted.emit(key)
		trigger_signal(key, null)
		
## Method returns whether there are any keys in the Storage
func is_empty():
	return data.is_empty()

## Add a signal for a specific key
func add_signal(signal_name: String):
	if not signals.has(signal_name):
		signals[signal_name] = Signal(signals, signal_name)

## Trigger a signal for a specific key
func trigger_signal(signal_name: String, arg: Variant = null):
	if not signals.has_signal(signal_name):
		add_signal(signal_name)

	var target = signals[signal_name].emit(arg)