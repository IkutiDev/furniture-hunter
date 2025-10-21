extends Control

@export var type : CollectionSet.Types
@export var icon : TextureRect

func _ready() -> void:
	set_type(type)

func set_icon(new_texture : Texture):
	icon.texture = new_texture
	pass


func set_type(new_type : CollectionSet.Types):
	type = new_type
	set_icon(CollectionSet.get_set_icon(new_type))
	pass
