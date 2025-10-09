class_name SetItemPriceUI
extends Control

@export var furniture_title_label : Label
@export var furniture_description_label : Label
@export var close_ui_button : BaseButton
@export var item_list : Control
@export var item_button_scene : PackedScene
@export var item_slots_list : Control
@export var item_slot_ui_scene : PackedScene

var furniture_instance : FurnitureContainerInstance

func _ready() -> void:
	EventBus.available_items_changed.connect(update_items_inventory)
	EventBus.clicked_on_furniture.connect(open_ui)
	EventBus.clicked_on_item.connect(set_item_inside_container)
	close_ui_button.pressed.connect(close_ui)
	close_ui()


func open_ui(instance: FurnitureContainerInstance) -> void:
	if instance == null:
		return
	if visible:
		return
	furniture_instance = instance
	furniture_title_label.text = furniture_instance.furniture_data.furniture_name
	furniture_description_label.text = furniture_instance.furniture_data.furniture_description
	update_item_slots()
	show()
	
func close_ui() -> void:
	furniture_instance = null
	hide()


func update_item_slots() -> void:
	var children = item_slots_list.get_children()
	for c in children:
		c.queue_free()
	for s in furniture_instance.item_slots:
		var item_slot_instance := item_slot_ui_scene.instantiate() as ItemSlotUI
		item_slot_instance.set_item_slot(s)
		item_slots_list.add_child(item_slot_instance)

func update_items_inventory() -> void:
	var children = item_list.get_children()
	for c in children:
		c.queue_free()
	for i in PlayerInventory.items:
		var item_button_instance := item_button_scene.instantiate() as ItemButton
		item_button_instance.set_data(i)
		item_list.add_child(item_button_instance)

func set_item_inside_container(data : ItemData) -> void:
	if furniture_instance == null:
		return
	if data == null:
		return
	for i in furniture_instance.item_slots.size():
		if furniture_instance.item_slots[i].item_data == null:
			furniture_instance.item_slots[i].set_data(data)
			(item_slots_list.get_child(i) as ItemSlotUI).set_item_slot(furniture_instance.item_slots[i])
			PlayerInventory.remove_object_from_inventory(data)
			return
