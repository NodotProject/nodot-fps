extends StaticInteractBody3D

@export var fgd_model = {
  "path": "models/collectable/Chest_Closed.fbx",
  "scale": 0.2
}

@onready var inventory_root_node = $VBoxContainer

func toggle_inventory():
	if inventory_root_node.visible:
		inventory_root_node.visible = false
		PlayerManager.node.input_enabled = true
		label_text = "Open Chest"
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		inventory_root_node.visible = true
		PlayerManager.node.input_enabled = false
		label_text = ""
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
