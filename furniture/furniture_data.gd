class_name FurnitureData
extends Resource

@export var ID : int
@export var object_name : String
@export_multiline var description : String
@export var icon : Texture2D
@export var base_value : int
@export var renown : int
@export var collection_set_type : CollectionSet.Types
@export var furniture_scene : PackedScene
@export var tags : Array[Tags.Types]
@export var can_be_sold = true

@export_group("Lootbox Variables")
@export_enum("Common:0", "Uncommon:1", "Rare:2", "Legendary:3") var rarity_type : int
@export var rarity_weight : float

var perfect_price : int:
	get:
		return base_value + base_value * (PlayerInventory.renown as float / PlayerInventory.MAX_RENOWN as float)

func get_visual_mesh() -> Mesh:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh()
func get_scale() -> Vector3:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh_scale()
func get_rotation() -> Vector3:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh_rotation()
func get_offset() -> Vector3:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh_offset()
func get_extra_spaces() -> PackedVector3Array:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.extra_size
