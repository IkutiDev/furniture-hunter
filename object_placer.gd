extends Node

const MAGICAL_Z_NUMBER = 0.2 # Without this raycasting position where the furnitue should go is fucked. I dont know why

@export var occupation_grid_map : GridMap
@export var visual_mesh_parent : Node3D
@export var visual_mesh : MeshInstance3D
@export var can_place_material : StandardMaterial3D
@export var cant_place_material : StandardMaterial3D
@export var nav_mesh_region : NavigationRegion3D
var selected_furniture : FurnitureData = null
var current_mouse_position_on_grid : Vector3 = Vector3.ZERO
var current_rotation_in_degrees : float = 0.0
var can_place_furniture : bool = false
var hovered_over_furniture_instance : FurnitureInstance = null
var delete_mode_active : bool = false

func _ready() -> void:
	selected_furniture = null
	EventBus.deselect_current_furniture.connect(deselect_furniture)
	EventBus.selected_furniture_to_place.connect(select_furniture)
	EventBus.set_remove_furniture_mode.connect(toggled_delete_mode)
	EventBus.mouse_over_furniture.connect(hover_over_furniture)
	EventBus.mouse_exits_furniture.connect(exit_hover_over_furniture)
	EventBus.object_sold.connect(update_navmesh)
	EventBus.start_day.connect(_on_day_started)
	
func _on_day_started() -> void:
	deselect_furniture()
	
func update_navmesh(instance : FurnitureInstance) -> void:
	await get_tree().process_frame
	nav_mesh_region.bake_navigation_mesh()
	
func deselect_furniture() -> void:
	selected_furniture = null

func select_furniture(data : FurnitureData) -> void:
	if GameManager.game_state == GameManager.GameState.DAY:
		return
	selected_furniture = data

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
	visual_mesh.scale = selected_furniture.get_scale()
	visual_mesh.position = selected_furniture.get_offset()
	
func toggled_delete_mode(active : bool) -> void:
	delete_mode_active = active

func hover_over_furniture(instance : FurnitureInstance) -> void:
	if instance == null:
		return
	hovered_over_furniture_instance = instance
func exit_hover_over_furniture(instance : FurnitureInstance) -> void:
	if instance == null:
		return
	if hovered_over_furniture_instance == instance:
		hovered_over_furniture_instance = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("press"):
		if can_place_furniture and selected_furniture != null:
			place_object()
		elif hovered_over_furniture_instance != null and delete_mode_active:
			remove_object()
	if event.is_action_pressed("right_click"):
		if can_place_furniture and selected_furniture != null:
			deselect_furniture()
	if event.is_action_pressed("rotate"):
		current_rotation_in_degrees += 90.0
		if current_rotation_in_degrees >= 360.0:
			current_rotation_in_degrees = 0.0
		visual_mesh_parent.rotation_degrees = Vector3(0, current_rotation_in_degrees, 0)

func place_object() -> void:
	var furnitue_instance := selected_furniture.furniture_scene.instantiate() as FurnitureInstance
	furnitue_instance.position =  occupation_grid_map.map_to_local(current_mouse_position_on_grid)
	furnitue_instance.rotation_degrees = Vector3(0, current_rotation_in_degrees, 0)
	furnitue_instance.furniture_data = selected_furniture
	nav_mesh_region.add_child(furnitue_instance)
	nav_mesh_region.bake_navigation_mesh()
	occupation_grid_map.set_cell_item(current_mouse_position_on_grid, 1)
	for p in furnitue_instance.extra_size:
		p = p.rotated(Vector3.MODEL_TOP, deg_to_rad(current_rotation_in_degrees))
		occupation_grid_map.set_cell_item(current_mouse_position_on_grid + p, 1)
	PlayerInventory.remove_object_from_inventory(selected_furniture)
	deselect_furniture()

func remove_object() -> void:
	var furniture_position := occupation_grid_map.local_to_map(hovered_over_furniture_instance.position)
	occupation_grid_map.set_cell_item(furniture_position, 0)
	for p in hovered_over_furniture_instance.extra_size:
		p = p.rotated(Vector3.MODEL_TOP, deg_to_rad(hovered_over_furniture_instance.rotation_degrees.y))
		occupation_grid_map.set_cell_item(current_mouse_position_on_grid + p, 0)
	hovered_over_furniture_instance.remove_this_instance()
	nav_mesh_region.bake_navigation_mesh()

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
