extends Node

@export var furniture : Array[FurnitureData]
@export var items : Array[ItemData]
@export var lootboxes : Array[LootboxData]
@export var collections : Array[CollectionData]
@export var money : int

var renown : int = 0
const MAX_RENOWN = 9000

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

func change_renown_amount(addtivie_renown_amount : int) -> void:
	renown += addtivie_renown_amount

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

func add_collection_to_inventory(collection_data : CollectionData):
	collections.append(collection_data)
	EventBus.emit_signal("available_collections_changed")
	pass

func create_collection(collection_data : CollectionData):
	for part in collection_data.parts:
		if part is FurnitureData:
			remove_furniture_from_inventory(part)
		if part is ItemData:
			items.erase(part)
			EventBus.available_items_changed.emit()
	add_collection_to_inventory(collection_data)
