extends Node3D

@export var fgd_model = {
  "path": "models/spawner/FixdMsh.fbx",
  "scale": 0.01
}

func _ready():
	update_labels(0)
	$Spawner3D.connect("spawns_left_updated", update_labels)
	
func update_labels(_spawns_left):
	$Current.text = "Current: %s" % ($Spawner3D.spawn_limit - $Spawner3D.spawns_left)
	$SpawnLimit.text = "Limit: %s" % $Spawner3D.spawn_limit
