extends Control


@export var crafting_menu : Control
@export var open_menu_button : BaseButton

@export var recipes_go_here : Control
@export var crafting_recipe_scene : PackedScene

@export var collection_sets : Array[Resource] # this needs to be fixed in refactor

#var loaded_recepies : Array[CollectionSet.Types]
var completed_collections : Array[CollectionSet.Types]

func _ready() -> void:
	completed_collections.push_back(CollectionSet.Types.NONE)

	open_menu_button.pressed.connect(_toggle_auctions_menu)
	
	EventBus.collection_crafted.connect(Callable(PlayerInventory,"create_collection"))
	EventBus.collection_crafted.connect(add_collection_to_completed)
	

	crafting_menu.visible = false
	
func _toggle_auctions_menu() -> void:
	crafting_menu.visible = !crafting_menu.visible
	if crafting_menu.visible:
		create_recepies()


func create_recepies():
	for old in $Panel/ScrollContainer/VBoxContainer.get_children():
		old.queue_free()
	# go through every item and furniture in inventory to get every collection type that needs to get loaded
	var collections_to_load = Dictionary()
	
	for furniture in PlayerInventory.furniture:
		var inspected_collection_type = furniture.collection_set_type
		if inspected_collection_type != CollectionSet.Types.NONE:
			if !collections_to_load.keys().has(inspected_collection_type):
				collections_to_load[inspected_collection_type] = [furniture]
				
			else:
				collections_to_load[inspected_collection_type].push_back(furniture)

			

	for item in PlayerInventory.items:
		var inspected_collection_type = item.collection_set_type
		if inspected_collection_type != CollectionSet.Types.NONE:
			if !collections_to_load.keys().has(inspected_collection_type):
				collections_to_load[inspected_collection_type] = [item]
			else:
				collections_to_load[inspected_collection_type].push_back(item)
	
	# remove loaded and completed colletions from list
	
	#for l in loaded_recepies:
		#collections_to_load.erase(l)

	for c in completed_collections:
		collections_to_load.erase(c)
	for K in collections_to_load:
		print(K," ")
		for H in collections_to_load[K]:
			print(H.object_name, ";")
	
	# for each type in collections_to_load create a recipe
	for collection in collections_to_load.keys():
		var new_recpie = crafting_recipe_scene.instantiate()
		new_recpie.collection_data = collection_sets[collection]
		new_recpie.connect("failed_to_craft",throw_error)
		new_recpie.load_recipe(collections_to_load[collection])
		$Panel/ScrollContainer/VBoxContainer.add_child(new_recpie)
		#loaded_recepies.push_back(collection)
	pass

func throw_error(message : String):
	$Panel/ErrorMessage.text = message
	$Panel/ErrorMessage/Anime.play("fade_out")
	pass


func add_collection_to_completed(collection_data : CollectionData):
	completed_collections.append(collection_data.collection_set_type)
	pass
