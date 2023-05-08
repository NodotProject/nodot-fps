extends Entity

@export var fgd_model = {
  "path": "models/MilitaryTarget.fbx",
  "scale": 0.15
}

func _ready():
	var target_node_position = get_target(target).global_position
	if target_node_position:
		$Mover3D.destination_position = target_node_position

func _on_health_health_changed(old_health, new_health):
	$TextEmitter.action(str(round(new_health - old_health)))

func _on_health_health_depleted():
	$Mover3D.activate()

func _on_health_health_gained(_old_health, _new_health):
	$Mover3D.deactivate()

func action():
	$MilitaryTarget/Health.set_health(100)
