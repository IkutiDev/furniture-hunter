class_name NewItemSlotUI
extends VBoxContainer


@export var item_icon_button : Control
@export var empty_slot_data : ItemData
@export var recommeneded_price_label : Label
@export var current_price_label : Label
@export var price_box : SpinBox
@export var set_price_button : Control

@export var item_title_label : Label
@export var item_description_label : Label






var item_instance : ItemInstance

func _ready() -> void:
	set_price_button.pressed.connect(set_the_price)
	item_icon_button.gui_input.connect(on_icon_clicked)
	
func on_icon_clicked(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		remove_item_from_item_slot()

func remove_item_from_item_slot() -> void:
	item_instance.current_price = -1
	PlayerInventory.add_object_to_inventory(item_instance.item_data)
	item_instance.set_data(null)
	update_item_slot_ui()

func set_item_slot(current_item_instance : ItemInstance) -> void:
	item_instance = current_item_instance
	update_item_slot_ui()

func update_item_slot_ui() -> void: # TUTAJ
	if item_instance.item_data == null:
		recommeneded_price_label.text = "0"
		current_price_label.text = "0"
		price_box.value = 0
		item_icon_button.set_data(empty_slot_data)
		item_title_label.text = ""
		item_description_label.text = ""
	else:
		recommeneded_price_label.text = str(item_instance.item_data.base_value)
		price_box.value = item_instance.current_price if item_instance.current_price >= 0 else 0
		item_icon_button.set_data(item_instance.item_data)
		item_title_label.text = item_instance.item_data.object_name
		item_description_label.text = item_instance.item_data.description





func set_the_price() -> void:
	if item_instance == null:
		return
	if item_instance.item_data == null:
		return
	@warning_ignore("narrowing_conversion")
	item_instance.set_price(price_box.value)
	current_price_label.text = str(item_instance.current_price if item_instance.current_price >= 0 else 0)
