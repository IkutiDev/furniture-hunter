extends Node3D

@export var floor_grid_map : GridMap
@export var occupation_grid_map : GridMap

@export var wall_grid_map : GridMap


func _ready() -> void:
	#var floor_offset = Vector3i(-1,0,0)
	#for t in floor_grid_map.get_used_cells():
		#if occupation_grid_map.get_cell_item(t) == GridMap.INVALID_CELL_ITEM:
			#occupation_grid_map.set_cell_item(t, 0)
	EventBus.available_items_changed.emit()
	EventBus.available_furniture_changed.emit()
	EventBus.available_collections_changed.emit()
	EventBus.renown_value_changed.emit()
	EventBus.connect("wallpaper_changed",next_wall)
	#$CashTable.connect("cash_pressed",next_wall)

	
#func change_floor(tile : int): # DO NOT USE KILLS NAV MESH
	#for cell in floor_grid_map.get_used_cells():
		#floor_grid_map.set_cell_item(cell,tile)
	#await  get_tree().create_timer(1.0).timeout
	#$NavigationRegion3D.bake_navigation_mesh()
	#pass
func next_wall():
	var current_item = wall_grid_map.get_cell_item(Vector3i(0, 0, -2))
	if current_item == 5:
		current_item = 0
	else:
		current_item += 1
	change_walls(current_item)
	pass

func change_walls(tile : int):
	for wall in wall_grid_map.get_used_cells():
		wall_grid_map.set_cell_item(wall,tile,wall_grid_map.get_cell_item_orientation(wall))
