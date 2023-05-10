extends Node3D

@export var color: Color = Color.WHITE

func _enter_tree():
	if color != Color.WHITE:
		var material = $MeshInstance3D.get_active_material(0).duplicate(15)
		material.emission = color
		$MeshInstance3D.set_surface_override_material(0, material)
		$SpotLight3D.light_color = color
