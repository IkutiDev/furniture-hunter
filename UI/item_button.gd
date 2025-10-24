class_name ItemButton
extends TextureButton

var data : ItemData

@export var set_icon : Control
@export var slot_icon : Control
@export var amount_label : Label
@export var stored = false

func _ready() -> void:
	pressed.connect(_on_pressed_item_button)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit_hover)

func set_data(_data : ItemData, amount : int = 1) -> void:
	data = _data
	texture_normal = data.icon
	set_icon.set_type(data.collection_set_type)
	slot_icon.set_rarity(data.rarity_type)
	if amount <= 1:
		amount_label.hide()
	else:
		amount_label.show()
		amount_label.text = str(amount)

func _on_pressed_item_button() -> void:
	if !stored:
		EventBus.clicked_on_item.emit(data)

func _on_hover() -> void:
	if !stored:
		EventBus.on_icon_hovered.emit(self, data)

func _on_exit_hover() -> void:
	EventBus.on_icon_hovered.emit(null, null)
