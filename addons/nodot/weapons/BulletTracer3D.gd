## A 3D bullet tracer effect that can be attached to a weapon.
class_name BulletTracer3D extends Nodot3D

@export var enabled: bool = true
## The magazine to trigger the effect
@export var magazine: Magazine

var mesh_instance := MeshInstance3D.new()

func _enter_tree() -> void:
	var mesh := RibbonTrailMesh.new()
	mesh.size = 0.015
	mesh.sections = 2
	mesh.section_segments = 1
	mesh.section_length = 0.5
	
	var mesh_material = StandardMaterial3D.new()
	mesh_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	var gradient_texture = GradientTexture2D.new()
	var gradient = Gradient.new()
	gradient.offsets = [Vector2(0.5, 0.0), Vector2(0.5, 1.0)]
	gradient.colors = [Color.WHITE, Color.BLACK]
	gradient_texture.gradient = gradient
	
	mesh_material.albedo_texture = gradient_texture
	
	mesh.material = mesh_material
	mesh_instance.mesh = mesh
	
	mesh_instance.rotation.z = -(PI / 2)
	mesh_instance.position.z = -mesh.section_length

func action():
	pass
