extends Entity

@export var fgd_solid = true
@export var label_text: String = "Press E to interact"

func _enter_tree():
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	var mesh: MeshInstance3D = Nodot.get_first_child_of_type(self, MeshInstance3D)
	box_shape.size = mesh.get_aabb().size
	collision_shape.shape = box_shape
	add_child(collision_shape)

func interact():
	var new_target = get_target(target)
	if new_target and new_target.has_method("action"):
		new_target.action()

func label():
	return label_text
