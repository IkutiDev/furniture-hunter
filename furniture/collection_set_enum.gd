class_name CollectionSet

extends RefCounted
enum Types {
	NONE,
	#ALCHEMIST_PRIDE,
	#MAGICAL_ODDITIES,
	CHINESE_COLLECTION,
	WITCH_COLLECTION,
	EGYPTIAN_COLLECTION,
	KNIGHT_COLLECTION,
	GREEK_COLLECTION,
	UFO_COLLECTION,
}

static func get_set_icon(type : Types) -> Texture:
	match type:
		Types.CHINESE_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/ancient_china_collection_icon.png")
		Types.WITCH_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/witch_collection_icon.png")
		Types.EGYPTIAN_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/ancient_egypt_collection_icon.png")
		Types.KNIGHT_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/knight_collection_icon.png")
		Types.UFO_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/ufo_collection_icon.png")
		Types.GREEK_COLLECTION:
			return load("res://UI/UI_kasia/collections_menu/ancient_greece_collection_icon.png")
		_:
			return load("res://UI/UI_kasia/collections_menu/slot_grey.png")

static func get_set_name(type : Types) -> String:
	match type:
		#Types.ALCHEMIST_PRIDE:
			#return "[color=gold]Alchemists Pride[/color]"
		#Types.MAGICAL_ODDITIES:
			#return "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]Magical Odditites[/rainbow]"
		_:
			return "[color=white]"+Types.keys()[type].capitalize()+"[/color]"
	return "[color=white]None[/color]"
