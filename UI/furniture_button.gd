class_name FurnitureButton
extends TextureButton

var data : FurnitureData

func _ready() -> void:
	pressed.connect(_on_pressed_furniture_button)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit_hover)

func set_data(_data : FurnitureData) -> void:
	data = _data
	texture_normal = data.icon
	

func _on_pressed_furniture_button() -> void:
	EventBus.selected_furniture_to_place.emit(data)

func _on_hover() -> void:
	EventBus.on_icon_hovered.emit(self, data)

func _on_exit_hover() -> void:
	EventBus.on_icon_hovered.emit(null, null)
