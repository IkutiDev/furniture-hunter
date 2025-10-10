class_name ItemData
extends Resource

@export var object_name : String
@export var item_icon : Texture2D
@export var item_value : int
@export var collection_set_type : CollectionSet.Types
@export var item_scene : PackedScene
@export_group("Lootbox Variables")
@export var rarity_weight : float

var perfect_price : int:
	get:
		return item_value + item_value * (PlayerInventory.renown as float / PlayerInventory.MAX_RENOWN as float)
