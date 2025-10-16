class_name CollectionInstance
extends Node3D

var collection_data : CollectionData
#var current_price : int = -1
#var perfect_price : int:
	#get:
		#if collection_data != null:
			#return collection_data.perfect_price
		#else:
			#return -1

#@onready var for_sale_sign = preload("res://furniture/for_sale_sign.tscn").instantiate()

#func _ready() -> void:
	#add_child(for_sale_sign)
	

func set_data(new_data : CollectionData) -> void:
	for c in get_children():
		if c is StaticBody3D:
			continue
		#if c is Sprite3D:
			#continue
		c.queue_free()
	
	if new_data == null:
		#set_price(-1)
		if collection_data != null:
			PlayerInventory.change_renown_amount(-collection_data.renown)
	else:
		var collection_instance := new_data.collection_scene.instantiate()
		add_child(collection_instance)
		PlayerInventory.change_renown_amount(new_data.renown)
	collection_data = new_data
		
#func set_price(new_price : int) -> void:
	#current_price = new_price
	#if current_price > 0:
		#for_sale_sign.visible = true
		#EventBus.set_price.emit(self)
	#else:
		#for_sale_sign.visible = false
	


#func sold(offer) -> void:
	#PlayerInventory.earn_money(offer)
	#EventBus.object_sold.emit(self)
	#set_data(null)
	
