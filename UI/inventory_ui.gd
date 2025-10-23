class_name InventoryUI
extends Control
@export var inventory_visual_container : Control
@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene
@export var lootbox_button_scene : PackedScene
@export var collection_button_scene : PackedScene

@export var furniture_button : TextureButton
@export var items_button : TextureButton
@export var button_active_texture : Texture2D
@export var button_inactive_texture : Texture2D

@export var arrow_up_button : TextureButton
@export var arrow_down_button : TextureButton

var showing_furniture : bool  = true

var list_index : int = 0

func _ready() -> void:
	EventBus.available_furniture_changed.connect(update_furniture_inventory)
	EventBus.available_items_changed.connect(update_items_inventory)
	#EventBus.available_lootboxes_changed.connect(update_lootboxes_inventory)
#
	#EventBus.available_collections_changed.connect(update_collection_inventory)
	
	furniture_button.pressed.connect(show_furniture)
	items_button.pressed.connect(show_items)
	arrow_up_button.pressed.connect(go_up_in_list)
	arrow_down_button.pressed.connect(go_down_in_list)
	update_buttons_visuals()


func update_buttons_visuals() -> void:
	if showing_furniture:
		furniture_button.texture_normal = button_active_texture
		items_button.texture_normal = button_inactive_texture
	else:
		items_button.texture_normal = button_active_texture
		furniture_button.texture_normal = button_inactive_texture
		
	if list_index == 0:
		arrow_up_button.disabled = true
	else:
		arrow_up_button.disabled = false
		
	if showing_furniture:
		var furniture_dictionary := PlayerInventory.get_items_as_dictionary(PlayerInventory.ObjectType.FURNITURE)
		if furniture_dictionary.size() <= 8:
			arrow_down_button.disabled = true
		else:
			var max_index : int = (furniture_dictionary.size() - 1) / 8 
			if list_index >= max_index:
				arrow_down_button.disabled = true
			else:
				arrow_down_button.disabled = false
	else:
		var item_dictionary := PlayerInventory.get_items_as_dictionary(PlayerInventory.ObjectType.ITEM)
		if item_dictionary.size() <= 8:
			arrow_down_button.disabled = true
		else:
			var max_index : int = (item_dictionary.size() - 1) / 8 
			if list_index >= max_index:
				arrow_down_button.disabled = true
			else:
				arrow_down_button.disabled = false
	

func go_up_in_list() -> void:
	list_index -= 1
	update_buttons_visuals()
	if showing_furniture:
		show_furniture(list_index)
	else:
		show_items(list_index)
		
func go_down_in_list() -> void:
	list_index += 1
	update_buttons_visuals()
	if showing_furniture:
		show_furniture(list_index)
	else:
		show_items(list_index)

func show_furniture(index : int = 0) -> void:
	showing_furniture = true
	list_index = index
	update_furniture_inventory()
	update_buttons_visuals()
	
func show_items(index : int = 0) -> void:
	showing_furniture = false
	list_index = index
	update_items_inventory()
	update_buttons_visuals()

func open_menu() -> void:
	show()
	EventBus.menu_open.emit(self)
	update_buttons_visuals()
	if showing_furniture:
		show_furniture()
	else:
		show_items()

func close_menu() -> void:
	hide()
	EventBus.menu_close.emit(self)
	list_index = 0
	update_buttons_visuals()

	
func update_furniture_inventory() -> void:
	if not showing_furniture:
		return
	var children = inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	var furniture_dictionary := PlayerInventory.get_items_as_dictionary(PlayerInventory.ObjectType.FURNITURE)
	var index = list_index * 8
	var max_index = mini(((list_index + 1) * 8), furniture_dictionary.size())
	for i in range(index, max_index):
		var furniture_button_instance := furniture_button_scene.instantiate() as FurnitureButton
		var f = furniture_dictionary.keys()[i]
		furniture_button_instance.set_data(f, furniture_dictionary[f])
		furniture_button_instance.pressed.connect(press_furniture_button)
		inventory_visual_container.add_child(furniture_button_instance)


func update_items_inventory() -> void:
	if showing_furniture:
		return
	var children = inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	var items_dictionary := PlayerInventory.get_items_as_dictionary(PlayerInventory.ObjectType.ITEM)
	var index = list_index * 8
	var max_index = mini(((list_index + 1) * 8), items_dictionary.size())
	for i in range(index, max_index):
		var item_button_instance := item_button_scene.instantiate() as ItemButton
		var item = items_dictionary.keys()[i]
		item_button_instance.set_data(item, items_dictionary[item])
		inventory_visual_container.add_child(item_button_instance)
		
#func update_lootboxes_inventory() -> void:
	#var children = inventory_visual_container.get_children()
	#for c in children:
		#c.queue_free()
	#for l in PlayerInventory.lootboxes:
		#var lootbox_button_instance := lootbox_button_scene.instantiate() as LootboxButton
		#lootbox_button_instance.set_data(l)
		#inventory_visual_container.add_child(lootbox_button_instance)
#
#func update_collection_inventory() -> void:
	#var children = inventory_visual_container.get_children()
	#for c in children:
		#c.queue_free()
	#for col in PlayerInventory.collections:
		#var collection_button_instance := collection_button_scene.instantiate() as CollectionButton
		#collection_button_instance.set_data(col)
		#inventory_visual_container.add_child(collection_button_instance)

func press_furniture_button() -> void:
	close_menu()
