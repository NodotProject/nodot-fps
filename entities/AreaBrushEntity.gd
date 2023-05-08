class_name AreaBrushEntity extends Area3D

@export var fgd_solid = true
@export var target: String
@export var targetname: String

func get_target(target_name: String):
	var siblings = get_parent().get_children()
	for item in siblings:
		if "targetname" in item and item.targetname == target_name:
			return item
