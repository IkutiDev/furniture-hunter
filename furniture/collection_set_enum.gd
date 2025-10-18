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

static func get_set_name(type : Types) -> String:
	match type:
		#Types.ALCHEMIST_PRIDE:
			#return "[color=gold]Alchemists Pride[/color]"
		#Types.MAGICAL_ODDITIES:
			#return "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]Magical Odditites[/rainbow]"
		_:
			return "[color=white]"+Types.keys()[type].capitalize()+"[/color]"
	return "[color=white]None[/color]"
