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
	#await get_tree().create_timer(3.0).timeout
	#for cell in floor_grid_map.get_used_cells():
		#floor_grid_map.set_cell_item(cell,0)
	#await get_tree().create_timer(3.0).timeout
	#for cell in floor_grid_map.get_used_cells():
		#floor_grid_map.set_cell_item(cell,1)
	#await get_tree().create_timer(3.0).timeout
	#for cell in floor_grid_map.get_used_cells():
		#floor_grid_map.set_cell_item(cell,0)
