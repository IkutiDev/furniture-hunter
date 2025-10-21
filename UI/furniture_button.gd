class_name FurnitureButton
extends TextureButton

var data : FurnitureData

@export var slot_icon : Control
@export var set_icon : Control

func _ready() -> void:
	pressed.connect(_on_pressed_furniture_button)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit_hover)

func set_data(_data : FurnitureData) -> void:
	data = _data
	texture_normal = data.icon
	set_icon.set_type(data.collection_set_type)
	slot_icon.set_rarity(data.rarity_type)
	

func _on_pressed_furniture_button() -> void:
	EventBus.selected_furniture_to_place.emit(data)

func _on_hover() -> void:
	EventBus.on_icon_hovered.emit(self, data)

func _on_exit_hover() -> void:
	EventBus.on_icon_hovered.emit(null, null)
