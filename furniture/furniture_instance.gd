class_name FurnitureInstance
extends Node3D
@export var extra_size : PackedVector3Array
@export var visual_mesh : MeshInstance3D
@export var static_body : StaticBody3D
var furniture_data : FurnitureData

func _ready() -> void:
	static_body.mouse_entered.connect(_on_mouse_entered)
	static_body.mouse_exited.connect(_on_mouse_exit)
	
func _on_mouse_entered() -> void:
	EventBus.mouse_over_furniture.emit(self)
	
func _on_mouse_exit() -> void:
	EventBus.mouse_exits_furniture.emit(self)

func get_mesh_offset() -> Vector3:
	return visual_mesh.position

func get_mesh() -> Mesh:
	return visual_mesh.mesh

func remove_this_instance() -> void:
	PlayerInventory.add_object_to_inventory(furniture_data)
	queue_free()
