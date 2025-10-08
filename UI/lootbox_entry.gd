class_name LootboxEntry
extends HBoxContainer

@export var icon : TextureRect
@export var lootbox_title : Label
@export var lootbox_description : Label
@export var lootbox_price : Label
@export var buy_button : BaseButton

var lootbox_data : LootboxData

func _ready() -> void:
	buy_button.pressed.connect(bought_lootbox)

func set_data(data : LootboxData) -> void:
	lootbox_data = data
	icon.texture = data.icon
	lootbox_title.text = data.lootbox_title
	lootbox_description.text = data.lootbox_description
	lootbox_price.text = "Price: " + str(data.lootbox_price) + "$"

func bought_lootbox() -> void:
	if PlayerInventory.spend_money(lootbox_data.lootbox_price):
		PlayerInventory.add_object_to_inventory(lootbox_data)
