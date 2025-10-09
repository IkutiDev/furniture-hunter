class_name ItemSlotUI
extends HFlowContainer

@export var icon : TextureRect
@export var empty_icon : Texture2D
@export var recommeneded_price_label : Label
@export var price_spin_box : SpinBox
@export var set_price_button : Button

var item_slot : ItemSlot

func _ready() -> void:
	set_price_button.pressed.connect(set_the_price)
	icon.gui_input.connect(on_icon_clicked)
	
func on_icon_clicked(event : InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		remove_item_from_item_slot()

func remove_item_from_item_slot() -> void:
	item_slot.current_price = -1
	PlayerInventory.add_object_to_inventory(item_slot.item_data)
	item_slot.set_data(null)
	update_item_slot_ui()

func set_item_slot(current_item_slot : ItemSlot) -> void:
	item_slot = current_item_slot
	update_item_slot_ui()

func update_item_slot_ui() -> void:
	if item_slot.item_data == null:
		recommeneded_price_label.text = "0$"
		price_spin_box.value = 0
		icon.texture = empty_icon
	else:
		recommeneded_price_label.text = str(item_slot.item_data.item_value) +"$"
		price_spin_box.value = item_slot.current_price if item_slot.current_price >= 0 else 0
		icon.texture = item_slot.item_data.item_icon

func set_the_price() -> void:
	if item_slot == null:
		return
	if item_slot.item_data == null:
		return
	@warning_ignore("narrowing_conversion")
	item_slot.current_price = price_spin_box.value
