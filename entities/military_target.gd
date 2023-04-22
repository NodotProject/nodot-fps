extends StaticBody3D

@export var fgd_model = {
  "path": "models/MilitaryTarget.fbx",
  "scale": 0.2
}

@onready var health: Health = $Health

func label():
  return "%s health remaining. Press E to reset." % str(round($Health.current_health))

func interact():
  $Health.set_health(100)

func _on_health_health_changed(old_health, new_health):
  $TextEmitter.action(str(round(new_health - old_health)))
