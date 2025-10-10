class_name FurnitureData
extends Resource
@export var object_name : String
@export_multiline var furniture_description : String
@export var furniture_icon : Texture2D
@export var furniture_renown : int
@export var furniture_base_value : int
@export var collection_set_type : CollectionSet.Types
@export var furniture_scene : PackedScene
@export_group("Lootbox Variables")
@export var rarity_weight : float

var perfect_price : int:
	get:
		return furniture_base_value + furniture_base_value * (PlayerInventory.renown as float / PlayerInventory.MAX_RENOWN as float)

func get_visual_mesh() -> Mesh:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh()
func get_offset() -> Vector3:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh_offset()
func get_extra_spaces() -> PackedVector3Array:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.extra_size
