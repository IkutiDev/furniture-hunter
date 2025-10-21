class_name ItemButton
extends TextureButton

var data : ItemData

@export var amount_counter : Label
@export var set_icon : Control
@export var slot_icon : Control

func _ready() -> void:
	pressed.connect(_on_pressed_item_button)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit_hover)

func set_data(_data : ItemData) -> void:
	data = _data
	texture_normal = data.icon
	set_icon.set_type(data.collection_set_type)
	slot_icon.set_rarity(data.rarity_type)

func _on_pressed_item_button() -> void:
	EventBus.clicked_on_item.emit(data)

func _on_hover() -> void:
	EventBus.on_icon_hovered.emit(self, data)

func _on_exit_hover() -> void:
	EventBus.on_icon_hovered.emit(null, null)
