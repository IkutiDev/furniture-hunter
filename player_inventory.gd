extends Node

@export var furniture : Array[FurnitureData]
@export var items : Array[ItemData]

@export var money : int

func spend_money(amount : int) -> bool:
	if money - amount < 0:
		return false
	money -= amount
	return true

func earn_money(amount : int) -> void:
	money += amount

func remove_furniture_from_inventory(data : FurnitureData) -> void:
	furniture.erase(data)
	EventBus.available_furniture_changed.emit()

func add_furniture_to_inventory(data : FurnitureData) -> void:
	furniture.append(data)
	EventBus.available_furniture_changed.emit()
