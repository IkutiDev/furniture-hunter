class_name CollectionData
extends Resource

@export var ID : int
@export var object_name : String
@export_multiline var description : String
@export var icon : Texture2D
@export var base_value : int
@export var renown : int



@export var tags : Array[Tags.Types]
@export var parts : Array[Resource]
@export var can_be_sold = false
@export var collection_set_type : CollectionSet.Types
@export_enum("Common:0", "Uncommon:1", "Rare:2", "Legendary:3") var rarity_type : int

var perfect_price : int:
	get:
		return base_value + base_value * (PlayerInventory.renown as float / PlayerInventory.MAX_RENOWN as float)
