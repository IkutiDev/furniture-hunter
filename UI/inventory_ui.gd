class_name InventoryUI
extends Control
@export var main_inventory_fold_container : FoldableContainer
@export var furniture_inventory_visual_container : Control
@export var items_inventory_visual_container : Control
@export var lootboxes_inventory_visual_container : Control
@export var collection_inventory_visual_container : Control
@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene
@export var lootbox_button_scene : PackedScene
@export var collection_button_scene : PackedScene

@export var money_label : Label

func _ready() -> void:
	EventBus.available_furniture_changed.connect(update_furniture_inventory)
	EventBus.available_items_changed.connect(update_items_inventory)
	EventBus.available_lootboxes_changed.connect(update_lootboxes_inventory)
	EventBus.money_value_changed.connect(on_money_value_changed)
	EventBus.available_collections_changed.connect(update_collection_inventory)
	update_furniture_inventory()
	on_money_value_changed()
	
func on_money_value_changed() -> void:
	money_label.text = str(PlayerInventory.money) + "$"

func update_furniture_inventory() -> void:
	var children = furniture_inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	for f in PlayerInventory.furniture:
		var furniture_button_instance := furniture_button_scene.instantiate() as FurnitureButton
		furniture_button_instance.set_data(f)
		furniture_button_instance.pressed.connect(press_furniture_button)
		furniture_inventory_visual_container.add_child(furniture_button_instance)

func update_items_inventory() -> void:
	var children = items_inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	for i in PlayerInventory.items:
		var item_button_instance := item_button_scene.instantiate() as ItemButton
		item_button_instance.set_data(i)
		items_inventory_visual_container.add_child(item_button_instance)
		
func update_lootboxes_inventory() -> void:
	var children = lootboxes_inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	for l in PlayerInventory.lootboxes:
		var lootbox_button_instance := lootbox_button_scene.instantiate() as LootboxButton
		lootbox_button_instance.set_data(l)
		lootboxes_inventory_visual_container.add_child(lootbox_button_instance)

func update_collection_inventory() -> void:
	var children = collection_inventory_visual_container.get_children()
	for c in children:
		c.queue_free()
	for col in PlayerInventory.collections:
		var collection_button_instance := collection_button_scene.instantiate() as CollectionButton
		collection_button_instance.set_data(col)
		collection_inventory_visual_container.add_child(collection_button_instance)

func press_furniture_button() -> void:
	EventBus.set_remove_furniture_mode.emit(false)
	main_inventory_fold_container.fold()
