class_name ItemInstance
extends Node3D

var item_data : ItemData
var current_price : int = -1
var perfect_price : int:
	get:
		if item_data != null:
			return item_data.perfect_price
		else:
			return -1

@onready var for_sale_sign = preload("res://furniture/for_sale_sign.tscn").instantiate()

func _ready() -> void:
	add_child(for_sale_sign)

func set_data(data : ItemData) -> void:
	for c in get_children():
		if c is StaticBody3D:
			continue
		if c is Sprite3D:
			continue
		c.queue_free()
	item_data = data
	if data == null:
		set_price(-1)
	else:
		var item_instance := item_data.item_scene.instantiate()
		add_child(item_instance)
func set_price(new_price : int) -> void:
	current_price = new_price
	if current_price > 0:
		for_sale_sign.visible = true
		EventBus.set_price.emit(self)
	else:
		for_sale_sign.visible = false
	
func sold() -> void:
	PlayerInventory.earn_money(current_price)
	EventBus.object_sold.emit(self)
	set_data(null)
	
