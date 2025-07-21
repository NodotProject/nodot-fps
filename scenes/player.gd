extends FirstPersonCharacter

@export var inventory: CollectableInventory

func collect(collectable: RigidCollectable3D):
	return inventory.add(collectable.collectable.display_name, collectable.quantity)
