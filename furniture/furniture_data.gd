class_name FurnitureData
extends Resource
@export var furniture_name : String
@export_multiline var furniture_description : String
@export var furniture_icon : Texture2D
@export var furniture_renown : int
@export var furniture_base_value : int
@export var furniture_scene : PackedScene
@export_group("Lootbox Variables")
@export var rarity_weight : float

func get_visual_mesh() -> Mesh:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh()
func get_offset() -> Vector3:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.get_mesh_offset()
func get_extra_spaces() -> PackedVector3Array:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.extra_size
