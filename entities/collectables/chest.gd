extends StaticInteractBody3D

@export var fgd_model = {
  "path": "models/collectable/Chest_Closed.fbx",
  "scale": 0.2
}

@onready var inventory_root_node = $VBoxContainer

func toggle_inventory():
	if inventory_root_node.visible:
		inventory_root_node.visible = false
		PlayerManager.node.enable_input()
		label_text = "Open Chest"
	else:
		inventory_root_node.visible = true
		PlayerManager.node.disable_input()
		label_text = ""
