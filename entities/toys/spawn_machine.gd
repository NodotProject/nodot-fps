extends Node3D

@export var fgd_model = {
  "path": "models/spawner/spawner3d_new.obj",
  "scale": 0.01
}

func _ready():
	update_labels(0)
	$Spawner3D.connect("spawns_left_updated", update_labels)
	
func update_labels(_spawns_left):
	$SpawnLimit.text = "Current: %s" % ($Spawner3D.spawn_limit - $Spawner3D.spawns_left)
	$Current.text = "Limit: %s" % $Spawner3D.spawn_limit
