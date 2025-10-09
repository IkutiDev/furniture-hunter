class_name FurnitureContainerInstance
extends FurnitureInstance

@export var item_slots : Array[ItemInstance]

func sold_item(item : ItemInstance) -> void:
	if item_slots.find(item) == -1:
		return
	PlayerInventory.earn_money(item.current_price)
	item.set_data(null, self)
	slots_updated()

func slots_updated() -> void:
	for s in item_slots:
		if s.item_data != null:
			EventBus.set_price_on_furniture.emit(self)
			return
			
	EventBus.furniture_sold.emit(self)
