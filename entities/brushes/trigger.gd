extends AreaBrushEntity

func _ready():
	Nodot.get_first_child_of_type(self, MeshInstance3D).queue_free()
	connect("body_entered", get_target(target).action.unbind(1))
