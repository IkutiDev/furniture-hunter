@tool
extends Node

enum RarityType {COMMON, UNCOMMON, RARE, LEGENDARY}

@export_tool_button("Import Data from CSV") var import_action = import_from_csv
@export var csv_items_file_path : String
@export var csv_clients_file_path : String
@export var icons_file_path : String
@export var furniture_mesh_scenes_path : String
@export var items_mesh_scenes_path : String
@export var customers_scenes_path : String
func import_from_csv() -> void:
	
	var file = FileAccess.open(csv_items_file_path, FileAccess.READ)
	#ignore first line
	file.get_csv_line()
	while file.get_position() < file.get_length():
		var content = file.get_csv_line()
		var object_name : String = (content[1] as String).to_snake_case()
		var file_path =  "res://data/"+ content[0] + "_"+object_name+".tres"
		var data
		match content[12]:
			"Item":
				data = ItemData.new()
				data.item_scene = load(items_mesh_scenes_path + content[7] +".tscn")
				
			"Furniture":
				data = FurnitureData.new()
				data.furniture_scene = load(furniture_mesh_scenes_path + content[7] +".tscn")
				
		data.ID = content[0]
		data.object_name = content[1]
		data.description = content[2]
		data.icon = load(icons_file_path + content[3])
		data.base_value = (content[4] as String).to_int()
		data.renown = (content[5] as String).to_int()
		var collection_set_id = CollectionSet.Types.keys().find((content[6] as String).to_snake_case().to_upper())
		if collection_set_id == -1:
			if (content[6] as String).length() > 0:
				printerr(content[6])
			collection_set_id = 0
		data.collection_set_type = collection_set_id
		
		data.rarity_type = RarityType.keys().find((content[8] as String).to_upper())
		var tags = (content[9] as String).split(";")
		for t in tags:
			data.tags.append(parse_tag(t))
		data.rarity_weight = (content[10] as String).to_int()
		var can_be_sold = content[11] as String
		if can_be_sold == "yes":
			data.can_be_sold = true
		else:
			data.can_be_sold = false
		ResourceSaver.save(data,file_path)
		print("Done "+object_name)
	
	file = FileAccess.open(csv_clients_file_path, FileAccess.READ)
	#ignore first line
	file.get_csv_line()
	while file.get_position() < file.get_length():
		var content = file.get_csv_line()
		var object_name : String = (content[0] as String).to_snake_case()
		var file_path =  "res://data/clients/"+object_name+".tres"
		var data : CustomerData = CustomerData.new()
		data.client_name = content[0]
		data.starting_money = randi_range((content[1] as String).to_int(), (content[2] as String).to_int())
		data.walk_speed = (content[3] as String).to_float()
		data.client_scene = load(customers_scenes_path + content[4] +".tscn")
		var tags = (content[5] as String).split(";")
		for t in tags:
			data.love_tags.append(parse_tag(t))
		tags = (content[6] as String).split(";")
		for t in tags:
			data.liked_tags.append(parse_tag(t))
		tags = (content[7] as String).split(";")
		for t in tags:
			data.disliked_tags.append(parse_tag(t))
		tags = (content[8] as String).split(";")
		for t in tags:
			data.hated_tags.append(parse_tag(t))
		ResourceSaver.save(data,file_path)

func parse_tag(t) -> int:
	var tag = Tags.Types.keys().find(t.to_upper())
	if tag == -1:
		printerr(t)
	return tag
