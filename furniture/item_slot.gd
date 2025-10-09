class_name ItemSlot
extends Node3D

var item_data : ItemData
var furniture_instance : FurnitureContainerInstance
var current_price : int = -1
var perfect_price : int:
	get:
		return item_data.furniture_base_value + item_data.furniture_base_value * (PlayerInventory.renown / PlayerInventory.MAX_RENOWN)

func set_data(data : ItemData, instance : FurnitureContainerInstance) -> void:
	for c in get_children():
		c.queue_free()
	item_data = data
	furniture_instance = instance
	if data == null:
		return
	var item_instance := item_data.item_scene.instantiate()
	add_child(item_instance)
func set_price(new_price : int) -> void:
	current_price = new_price
	furniture_instance.slots_updated()
