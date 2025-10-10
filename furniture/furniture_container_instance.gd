class_name FurnitureContainerInstance
extends FurnitureInstance

@export var item_slots : Array[ItemInstance]

func sold_item(item : ItemInstance) -> void:
	if item_slots.find(item) == -1:
		return
	PlayerInventory.earn_money(item.current_price)
	item.set_data(null)
