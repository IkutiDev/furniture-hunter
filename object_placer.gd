extends Node

const MAGICAL_Z_NUMBER = 0.2 # Without this raycasting position where the furnitue should go is fucked. I dont know why

@export var occupation_grid_map : GridMap
@export var visual_mesh_parent : Node3D
@export var visual_mesh : MeshInstance3D
@export var can_place_material : StandardMaterial3D
@export var cant_place_material : StandardMaterial3D
@export var selected_furniture : FurnitureData
var current_mouse_position_on_grid : Vector3 = Vector3.ZERO
var current_rotation_in_degrees : float = 0.0
var can_place_furniture : bool = false

func _process(_delta: float) -> void:
	visual_mesh.visible = selected_furniture != null
	if selected_furniture == null:
		return
	can_place_furniture = (not raycast_and_check_if_position_is_occupied()) and selected_furniture != null
	if can_place_furniture:
		visual_mesh.material_override = can_place_material
	else:
		visual_mesh.material_override = cant_place_material
	visual_mesh_parent.position = occupation_grid_map.map_to_local(current_mouse_position_on_grid)
	visual_mesh.mesh = selected_furniture.get_visual_mesh()
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place_object"):
		if can_place_furniture:
			place_object()
		else:
			print("cant place")
	if event.is_action_pressed("rotate"):
		current_rotation_in_degrees += 90.0
		if current_rotation_in_degrees >= 360.0:
			current_rotation_in_degrees = 0.0
		visual_mesh_parent.rotation_degrees = Vector3(0, current_rotation_in_degrees, 0)

func place_object() -> void:
	var furnitue_instance := selected_furniture.furniture_scene.instantiate() as FurnitureInstance
	furnitue_instance.position = occupation_grid_map.map_to_local(current_mouse_position_on_grid)
	furnitue_instance.rotation_degrees = Vector3(0, current_rotation_in_degrees, 0)
	get_tree().root.add_child(furnitue_instance)
	occupation_grid_map.set_cell_item(current_mouse_position_on_grid, 1)
	for p in furnitue_instance.extra_size:
		p = p.rotated(Vector3.MODEL_TOP, deg_to_rad(current_rotation_in_degrees))
		occupation_grid_map.set_cell_item(current_mouse_position_on_grid + p, 1)

func raycast_and_check_if_position_is_occupied() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var to = from + get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * ray_length
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.collide_with_bodies = true
	params.collide_with_areas = false
	var result = get_viewport().get_world_3d().direct_space_state.intersect_ray(params)
	if result.is_empty():
		return true
	
	var result_positon = occupation_grid_map.to_local(result.position)
	result_positon.z = result_positon.z - MAGICAL_Z_NUMBER
	var map_position := occupation_grid_map.local_to_map(result_positon)
	map_position.y = 0
	current_mouse_position_on_grid = map_position
	
	if occupation_grid_map.get_cell_item(map_position) == 0:
		if selected_furniture.get_extra_spaces().size() > 0:
			for p in selected_furniture.get_extra_spaces():
				p = p.rotated(Vector3.MODEL_TOP, deg_to_rad(current_rotation_in_degrees))
				if occupation_grid_map.get_cell_item(map_position + Vector3i(p)) != 0:
					return true
		return false
	else:
		return true
