extends Node

@export var furniture : Array[FurnitureData]
@export var items : Array[ItemData]

func remove_furniture_from_inventory(data : FurnitureData) -> void:
	furniture.erase(data)
	EventBus.available_furniture_changed.emit()

func add_furniture_to_inventory(data : FurnitureData) -> void:
	furniture.append(data)
	EventBus.available_furniture_changed.emit()
