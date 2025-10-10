class_name LootboxData
extends Resource

enum SpawnMethod {ONE_OF_EACH, RANDOM}

@export var icon : Texture2D
@export var lootbox_title : String
@export_multiline var lootbox_description : String
@export var lootbox_price : int
@export var renown_required : int
@export var special_deal_spawn_chance : int
@export var special_deal_time_min : float
@export var special_deal_time_max : float

@export var spawn_method : SpawnMethod
@export var random_elements_per_box: int
@export var furniture : Array[FurnitureData]
@export var items : Array[ItemData]

func spawn_objects() -> void:
	match spawn_method:
		SpawnMethod.ONE_OF_EACH:
			for f in furniture:
				PlayerInventory.add_object_to_inventory(f)
			for i in items:
				PlayerInventory.add_object_to_inventory(i)
		SpawnMethod.RANDOM:
			var rnd = RandomNumberGenerator.new()
			var random_elements_array : Array = []
			var random_elements_weight : Array = []
			for f in furniture:
				random_elements_array.append(f)
				random_elements_weight.append(f.rarity_weight)
			for i in items:
				random_elements_array.append(i)
				random_elements_weight.append(i.rarity_weight)
			for r in random_elements_per_box:
				var random_element = random_elements_array[rnd.rand_weighted(random_elements_weight)]
				PlayerInventory.add_object_to_inventory(random_element)
