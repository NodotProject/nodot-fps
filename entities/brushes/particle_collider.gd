extends StaticBrushEntity

func _ready():
	var mesh: MeshInstance3D = Nodot.get_first_child_of_type(self, MeshInstance3D)
	var aabb: AABB = mesh.get_aabb()
	var particle_collider = GPUParticlesCollisionBox3D.new()
	particle_collider.size = aabb.size
	add_child(particle_collider)
