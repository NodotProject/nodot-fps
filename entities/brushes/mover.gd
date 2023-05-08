extends StaticBrushEntity


@export var destination_position: Vector3 = Vector3.ZERO
@export var destination_rotation: Vector3 = Vector3.ZERO

func _enter_tree():
	$Mover3D.destination_position = destination_position
	$Mover3D.destination_rotation = destination_rotation

func action():
	$Mover3D.action()
