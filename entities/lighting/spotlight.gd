extends Node3D

@export var color: Color = Color.WHITE

func _enter_tree():
	if color != Color.WHITE:
		$MeshInstance3D.get_active_material(0).emission = color
		$SpotLight3D.light_color = color
