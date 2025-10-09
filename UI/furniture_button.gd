class_name FurnitureButton
extends TextureButton

var data : FurnitureData

@export var tooltip_panel : Control
@export var title_label : Label
@export var price_label : Label
@export var collection_set_label : RichTextLabel

func _ready() -> void:
	pressed.connect(_on_pressed_furniture_button)
	tooltip_panel.top_level = true
	tooltip_panel.position = pivot_offset + global_position

func set_data(_data : FurnitureData) -> void:
	data = _data
	texture_normal = data.furniture_icon
	title_label.text = data.furniture_name
	price_label.text = str(data.perfect_price)
	collection_set_label.text = CollectionSet.get_set_name(data.collection_set_type)
	

func _on_pressed_furniture_button() -> void:
	EventBus.selected_furniture_to_place.emit(data)
