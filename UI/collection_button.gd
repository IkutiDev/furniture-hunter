class_name CollectionButton
extends TextureButton

var data : CollectionData

func _ready() -> void:
	pressed.connect(_on_pressed_collection_button)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit_hover)

func set_data(_data : CollectionData) -> void:
	data = _data
	texture_normal = data.icon

func _on_pressed_collection_button() -> void:
	EventBus.clicked_on_collection.emit(data)

func _on_hover() -> void:
	EventBus.on_icon_hovered.emit(self, data)

func _on_exit_hover() -> void:
	EventBus.on_icon_hovered.emit(null, null)
