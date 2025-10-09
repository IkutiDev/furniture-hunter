class_name ItemSlot
extends Node3D

var item_data : ItemData
var current_price : int = -1

func set_data(data : ItemData) -> void:
	for c in get_children():
		c.queue_free()
	item_data = data
	if data == null:
		return
	var item_instance := item_data.item_scene.instantiate()
	add_child(item_instance)
func set_price(new_price : int) -> void:
	current_price = new_price
