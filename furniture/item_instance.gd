class_name ItemInstance
extends Node3D

var item_data : ItemData
var current_price : int = -1
var perfect_price : int:
	get:
		if item_data != null:
			return item_data.item_value + item_data.item_value * (PlayerInventory.renown / PlayerInventory.MAX_RENOWN)
		else:
			return -1

func set_data(data : ItemData) -> void:
	for c in get_children():
		if c is StaticBody3D:
			continue
		c.queue_free()
	item_data = data
	if data == null:
		current_price = -1
	else:
		var item_instance := item_data.item_scene.instantiate()
		add_child(item_instance)
func set_price(new_price : int) -> void:
	current_price = new_price
	EventBus.set_price.emit(self)
func sold() -> void:
	PlayerInventory.earn_money(current_price)
	EventBus.object_sold.emit(self)
	set_data(null)
	
