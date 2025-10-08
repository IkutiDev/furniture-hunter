extends Node

@export var furniture : Array[FurnitureData]
@export var items : Array[ItemData]
@export var lootboxes : Array[LootboxData]
@export var money : int

func remove_object_from_inventory(data) -> void:
	if data is FurnitureData:
		furniture.erase(data)
		EventBus.available_furniture_changed.emit()
	elif data is ItemData:
		items.erase(data)
		EventBus.available_items_changed.emit()
	elif data is LootboxData:
		lootboxes.erase(data)
		EventBus.available_lootboxes_changed.emit()
	else:
		print(data)
		print("Unknown element for inventory")


func spend_money(amount : int) -> bool:
	if money - amount < 0:
		return false
	money -= amount
	EventBus.money_value_changed.emit()
	return true

func earn_money(amount : int) -> void:
	money += amount
	EventBus.money_value_changed.emit()

func remove_furniture_from_inventory(data : FurnitureData) -> void:
	furniture.erase(data)
	EventBus.available_furniture_changed.emit()



func add_object_to_inventory(data) -> void:
	if data is FurnitureData:
		furniture.append(data)
		EventBus.available_furniture_changed.emit()
	elif data is ItemData:
		items.append(data)
		EventBus.available_items_changed.emit()
	elif data is LootboxData:
		lootboxes.append(data)
		EventBus.available_lootboxes_changed.emit()
	else:
		print(data)
		print("Unknown element for inventory")
