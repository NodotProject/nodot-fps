extends Node3D

@onready var character = get_parent().get_node("FirstPersonCharacterBody3D")

func _physics_process(_delta):
	global_position = Vector3(character.global_position.x, global_position.y, character.global_position.z)
