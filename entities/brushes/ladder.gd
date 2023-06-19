extends Ladder3D

@export var fgd_solid = true

func _ready():
	var mesh = Nodot.get_first_child_of_type(self, MeshInstance3D)
	if mesh:
		mesh.queue_free()
