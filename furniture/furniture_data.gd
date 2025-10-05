class_name FurnitureData
extends Resource
@export var furniture_name : String
@export var furniture_value : int
@export var furniture_scene : PackedScene

func get_visual_mesh() -> Mesh:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.visual_mesh

func get_extra_spaces() -> PackedVector3Array:
	var furniture_instance := furniture_scene.instantiate() as FurnitureInstance
	return furniture_instance.extra_size
