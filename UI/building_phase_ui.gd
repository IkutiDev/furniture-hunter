class_name BuildingUI
extends Control

@export var destroy_button : BaseButton
@export var main_inventory_fold_container : FoldableContainer
@export var furniture_inventory_visual_container : Control
@export var items_inventory_visual_container : Control
@export var lootboxes_inventory_visual_container : Control
@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene
@export var lootbox_button_scene : PackedScene

func _ready() -> void:
	destroy_button.pressed.connect(destroy_furniture_button_pressed)
	EventBus.available_furniture_changed.connect(update_furniture_inventory)
	EventBus.available_items_changed.connect(update_items_inventory)
	EventBus.available_lootboxes_changed.connect(update_lootboxes_inventory)
	update_furniture_inventory()
	
func destroy_furniture_button_pressed() -> void:
	EventBus.deselect_current_furniture.emit()
	EventBus.set_remove_furniture_mode.emit(true)

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

func press_furniture_button() -> void:
	EventBus.set_remove_furniture_mode.emit(false)
	main_inventory_fold_container.fold()
