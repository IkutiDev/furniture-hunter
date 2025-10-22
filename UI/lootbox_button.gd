class_name LootboxButton
extends Control

var data : LootboxData

@export var use_button : TextureButton
@export var name_label : Label
@export var icon_texture : TextureRect

func _ready() -> void:
	use_button.pressed.connect(_on_pressed_lootbox_button)

func set_data(_data : LootboxData) -> void:
	data = _data
	icon_texture.texture = data.icon
	name_label.text = data.lootbox_title

func _on_pressed_lootbox_button() -> void:
	EventBus.lootbox_opened.emit(data)

	PlayerInventory.remove_object_from_inventory(data)
	EventBus.update_auctions_ui.emit()
