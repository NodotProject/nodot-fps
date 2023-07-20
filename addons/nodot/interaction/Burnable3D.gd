## Allows 
class_name Burnable3D extends Nodot

## Enable the burnable3d node
@export var enabled: bool = true
## The target to detect collisions
@export var target: RigidBody3D
## Automatically ignite the target on spawn
@export var auto_ignite: bool = false
## Permanently at full effect and spreadable
@export var permanent: bool = false
## The time it takes before the effect start to spread
@export var time_to_spread: float = 1.0
## The time it takes for the fire effect to reach maximum
@export var time_to_full_effect: float = 2.0
## The time it takes to burn out from full effect (also stops spreading)
@export var time_to_burnout: float = 5.0
## (optional) The health node to apply damage
@export var health_node: Health
## (optional) Damage per second (0 for none) (health_node is required)
@export var damage_per_second: float = 0.0
## (optional) A Fire3D node to control fire effects
@export var fire3d_node: Fire3D
## (optional) the maximum effect scale for the fire3d_node (fire3d_node is required)
@export var full_effect_scale: float = 1.0

signal ignite_started
signal spreading_enabled
signal spreading_to(body: RigidBody3D)
signal full_effect_reached
signal burned_out

var ignited: bool = false
var non_burnables: Array[RID] = []
var spreadable: bool = false
var burning_timer: float = 0.0
var damage_tick: float = 0.0
var effect_scale_percentage: float = 0.0
var is_full_effect: bool = false

func _ready():
	if enabled and auto_ignite:
		ignited = true

func _physics_process(delta):
	if !enabled:
		return
		
	if ignited and !permanent:
		burning_timer += delta
		if time_to_spread > burning_timer:
			if !spreadable:
				spreadable = true
				emit_signal("spreading_enabled")
			
		if time_to_full_effect > burning_timer:
			effect_scale_percentage = burning_timer / time_to_full_effect
		elif time_to_burnout > burning_timer:
			if !is_full_effect:
				emit_signal("full_effect_reached")
			effect_scale_percentage = 1.0 - ((burning_timer - time_to_full_effect) / (time_to_burnout - time_to_full_effect))
		else:
			enabled = false
			reset()
			emit_signal("burned_out")
			
		if fire3d_node:
			fire3d_node.effect_scale = full_effect_scale / 100 * (effect_scale_percentage * 100)
		
		damage_tick += delta
		if damage_tick > 1.0 and is_instance_valid(health_node):
			damage_tick = 0.0
			health_node.add_health(-damage_per_second)

		
	if spreadable or permanent:
		var bodies = target.get_colliding_bodies()
		for body in bodies:
			var rid = body.get_rid()
			if !non_burnables.has(rid):
				var burnable = Nodot.get_first_child_of_type(body, Burnable3D)
				if burnable and burnable.enabled and !burnable.ignited:
					burnable.action()
				else:
					non_burnables.append(rid)
		
func action():
	if enabled:
		ignited = true
		emit_signal("ignite_started")

func reset():
	ignited = false
	spreadable = false
	burning_timer = 0.0
	effect_scale_percentage = 0.0
	is_full_effect = false
	damage_tick = 0.0
	if fire3d_node:
		fire3d_node.effect_scale = 0.0
