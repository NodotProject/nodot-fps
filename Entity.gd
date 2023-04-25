class_name Entity extends Node3D

@export var target: String
@export var targetname: String

func get_target(target_name: String):
  var siblings = get_parent().get_children()
  for item in siblings:
    if item.targetname == target_name:
      return item
