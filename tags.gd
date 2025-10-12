class_name Tags
extends RefCounted

enum Types {
	NONE,
	WITCH,
	EGYPT,
}

static func get_tag_name(type : Types) -> String:

	match type:
		_:
			return "[color=white]"+Types.keys()[type].capitalize()+"[/color]"
		#Types.ALCHEMIST_PRIDE:
			#return "[color=gold]Alchemists Pride[/color]"
		#Types.MAGICAL_ODDITIES:
			#return "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]Magical Odditites[/rainbow]"
	#return "[color=white]None[/color]"
