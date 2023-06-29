@tool
class_name Rain3D extends Nodot3D

@export var texture: Texture2D = load("res://addons/nodot/textures/raindrop.png")
@export var color: Color = Color(Color.WHITE, 0.3)
@export var amount: int = 200
@export var shaded: bool = false
@export var size: Vector2 = Vector2(10, 10)

var particles_node := GPUParticles3D.new()
var material := StandardMaterial3D.new()
var particle_material := ParticleProcessMaterial.new()

func _init():
	material.albedo_texture = texture
	material.albedo_color = color
	material.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	if shaded:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	else:
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	var mesh = PlaneMesh.new()
	mesh.size = Vector2(0.04, 0.2)
	mesh.orientation = PlaneMesh.FACE_Z
	mesh.material = material
	
	particle_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	particle_material.emission_box_extents = Vector3(size.x, 0.0, size.y)
	particle_material.gravity = Vector3(0.0, -30.0, 0.0)
	particle_material.collision_mode = ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT
	
	particles_node.process_material = particle_material
	particles_node.draw_pass_1 = mesh
	particles_node.emitting = true
	particles_node.amount = amount
	
	add_child(particles_node)
