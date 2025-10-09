class_name FurnitureContainerInstance
extends FurnitureInstance

@export var item_slots : Array[ItemSlot]

func sold_item(index : int) -> void:
	if index >= item_slots.size():
		printerr("index is too big")
	PlayerInventory.earn_money(item_slots[index].current_price)
	item_slots[index].set_data(null)
