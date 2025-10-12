@tool
extends Node

enum RarityType {COMMON, UNCOMMON, RARE, LEGENDARY}

@export_tool_button("Import Data from CSV") var import_action = import_from_csv
@export var csv_file_path : String
@export var icons_file_path : String
func import_from_csv() -> void:
	
	var file = FileAccess.open(csv_file_path, FileAccess.READ)
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
				
			"Furniture":
				data = FurnitureData.new()
				
		data.ID = content[0]
		data.description = content[2]
		data.object_name = content[1]
		data.base_value = (content[4] as String).to_int()
		data.renown = (content[5] as String).to_int()
		data.rarity_weight = (content[10] as String).to_int()
		data.rarity_type = RarityType.keys().find((content[8] as String).to_upper())
		var tags = (content[9] as String).split(";")
		for t in tags:
			data.tags.append(Tags.Types.keys().find(t.to_upper()))

		var collection_set_id = CollectionSet.Types.keys().find((content[6] as String).to_snake_case().to_upper())
		if collection_set_id == -1:
			collection_set_id = 0
		data.collection_set_type = collection_set_id
		data.icon = load(icons_file_path + content[3])
		var can_be_sold = content[11] as String
		if can_be_sold == "yes":
			data.can_be_sold = true
		else:
			data.can_be_sold = false
		ResourceSaver.save(data,file_path)
		print("Done "+object_name)
