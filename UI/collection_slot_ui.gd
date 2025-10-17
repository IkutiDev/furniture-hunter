class_name CollectionSlotUI
extends VFlowContainer

@export var icon : TextureRect
@export var empty_icon : Texture2D


var collection_instance : CollectionInstance

func _ready() -> void:

	icon.gui_input.connect(on_icon_clicked)
	
func on_icon_clicked(event : InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		remove_collection_from_collection_slot()

func remove_collection_from_collection_slot() -> void:
	#collection_instance.current_price = -1
	PlayerInventory.add_object_to_inventory(collection_instance.collection_data)
	collection_instance.set_data(null)
	update_collection_slot_ui()

func set_collection_slot(current_collection_instance : CollectionInstance) -> void:
	
	collection_instance = current_collection_instance
	update_collection_slot_ui()

func update_collection_slot_ui() -> void:
	if collection_instance.collection_data == null:
		#recommeneded_price_label.text = "0$"
		#price_spin_box.value = 0
		icon.texture = empty_icon
		$Name.text = ""
		$Description.text = ""
	else:
		#recommeneded_price_label.text = str(item_instance.item_data.base_value) +"$"
		#price_spin_box.value = item_instance.current_price if item_instance.current_price >= 0 else 0
		icon.texture = collection_instance.collection_data.icon
		$Name.text = collection_instance.collection_data.object_name
		$Description.text = collection_instance.collection_data.description

#func set_the_price() -> void:
	#if item_instance == null:
		#return
	#if item_instance.item_data == null:
		#return
	#@warning_ignore("narrowing_conversion")
	#item_instance.set_price(price_spin_box.value)
