class_name LootboxData
extends Resource

@export var icon : Texture2D
@export var lootbox_title : String
@export_multiline var lootbox_description : String
@export var lootbox_price : int
@export var renown_required : int
@export var special_deal_spawn_chance : int
@export var special_deal_time_min : float
@export var special_deal_time_max : float

@export var random_elements_per_box: int
@export var tags : Array[Tags.Types]

func spawn_objects() -> Array:
	var objects_spawned = []
	var eligble_data = []
	var rnd = RandomNumberGenerator.new()
	var random_elements_array : Array = []
	var random_elements_weight : Array = []
	var resources = ResourceLoader.list_directory("res://data")
	
	for r in resources:
		if (r as String).contains(".tres"):
			print(r)
			var resource = ResourceLoader.load("res://data/" + r)
			if resource is CollectionData:
				continue
			for t in tags:
				if resource.tags.find(t) != -1:
					eligble_data.append(resource)
			
	for d in eligble_data:
		random_elements_array.append(d)
		random_elements_weight.append(d.rarity_weight)
	for r in random_elements_per_box:
		var random_element = random_elements_array[rnd.rand_weighted(random_elements_weight)]
		PlayerInventory.add_object_to_inventory(random_element)
		objects_spawned.push_back(random_element)
	return objects_spawned
