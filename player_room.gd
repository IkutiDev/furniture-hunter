extends Node3D

@export var floor_grid_map : GridMap
@export var occupation_grid_map : GridMap

func _ready() -> void:
	for t in floor_grid_map.get_used_cells():
		if occupation_grid_map.get_cell_item(t) == GridMap.INVALID_CELL_ITEM:
			occupation_grid_map.set_cell_item(t, 0)
	EventBus.available_items_changed.emit()
	EventBus.available_furniture_changed.emit()
