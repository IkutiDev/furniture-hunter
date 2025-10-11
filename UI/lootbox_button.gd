class_name LootboxButton
extends TextureButton

var data : LootboxData

func _ready() -> void:
	pressed.connect(_on_pressed_lootbox_button)

func set_data(_data : LootboxData) -> void:
	data = _data
	texture_normal = data.icon

func _on_pressed_lootbox_button() -> void:
	EventBus.lootbox_opened.emit(data)

	PlayerInventory.remove_object_from_inventory(data)
