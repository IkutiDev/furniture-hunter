class_name ItemButton
extends TextureButton

var data : ItemData

func _ready() -> void:
	pressed.connect(_on_pressed_item_button)

func set_data(_data : ItemData) -> void:
	data = _data
	texture_normal = data.item_icon

func _on_pressed_item_button() -> void:
	EventBus.clicked_on_item.emit(data)
