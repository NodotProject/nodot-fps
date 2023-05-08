extends StaticBrushEntity

func _enter_tree():
  var collision_shape = CollisionShape3D.new()
  var box_shape = BoxShape3D.new()
  var mesh: MeshInstance3D = Nodot.get_first_child_of_type(self, MeshInstance3D)
  box_shape.size = mesh.get_aabb().size
  collision_shape.shape = box_shape
  add_child(collision_shape)
