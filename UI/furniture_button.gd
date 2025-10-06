class_name FurnitureButton
extends TextureButton

var data : FurnitureData

func _ready() -> void:
	pressed.connect(_on_pressed_furniture_button)

func set_data(_data : FurnitureData) -> void:
	data = _data
	texture_normal = data.furniture_icon

func _on_pressed_furniture_button() -> void:
	EventBus.selected_furniture_to_place.emit(data)
