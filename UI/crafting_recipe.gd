extends ColorRect

# needs to listen to inventory changes to update itslef accordingly

@export var collection_data : CollectionData

@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene
@export var collection_button_scene : PackedScene

func _ready() -> void:
	load_recipe()
	check_availability()
	EventBus.available_furniture_changed.connect(check_availability)
	EventBus.available_item_changed.connect(check_availability)

func load_recipe():
	for old in %ResultGoesHere.get_children():
		old.queue_free()
	for old in %PartsGoHere.get_children():
		old.queue_free()
	var result = collection_button_scene.instantiate() as CollectionButton
	result.set_data(collection_data)
	%ResultGoesHere.add_child(result)
	for thing_data in collection_data.parts:
		var next_part
		if thing_data is ItemData:
			next_part = item_button_scene.instantiate() as ItemButton
		if thing_data is FurnitureData:
			next_part = furniture_button_scene.instantiate() as FurnitureButton
		next_part.set_data(thing_data)
		%PartsGoHere.add_child(next_part)
	pass
	
func check_availability():
	# %PartsGoHere.get_children()
	# for every button - check in inventory if its there
	# if true - make eanbled
	# if flase - make disabled
	# if all 4 are active - eanble MakeSetButton
	# else - button diabled
	pass


func _on_make_set_button_pressed() -> void:
	# crafts set on press
	# needs to also remove the recipe once the thing is made
	pass # Replace with function body.
