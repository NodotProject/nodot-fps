## A node to manage the idle state of a NodotCharacter3D
class_name CharacterIdle3D extends CharacterExtensionBase3D

func physics(delta: float) -> void:
	character.move_and_slide()
