extends ColorRect

# needs to listen to inventory changes to update itslef accordingly
signal failed_to_craft(message)

@export var collection_data : CollectionData

@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene
@export var collection_button_scene : PackedScene

func _ready() -> void:
	pass
	#check_availability()
	#EventBus.available_furniture_changed.connect(check_availability)
	#EventBus.available_items_changed.connect(check_availability)

func load_recipe(available_objects : Array):
	var result = collection_button_scene.instantiate() as CollectionButton
	result.set_data(collection_data)
	%ResultGoesHere.add_child(result)
	for thing_data in collection_data.parts:
		var next_part
		if thing_data is ItemData:
			next_part = item_button_scene.instantiate() as ItemButton
		if thing_data is FurnitureData:
			next_part = furniture_button_scene.instantiate() as FurnitureButton
		if available_objects.has(thing_data):
			next_part.modulate = Color("Dark Green")
		next_part.set_data(thing_data)
		%PartsGoHere.add_child(next_part)
	
	pass
	



func _on_make_set_button_pressed() -> void: # crafts set on press
	# if collection cant be craffter -> return
	for part in collection_data.parts:

		if part is FurnitureData:
			if !PlayerInventory.furniture.has(part):
				failed_to_craft.emit("YOU ARE MISSING A PART OF THIS COLLECTION")
				return
		if part is ItemData:
			if !PlayerInventory.items.has(part):
				failed_to_craft.emit("YOU ARE MISSING A PART OF THIS COLLECTION")
				return

	EventBus.collection_crafted.emit(collection_data)
	queue_free()
	
	# needs to also remove the recipe once the thing is made
	pass # Replace with function body.
