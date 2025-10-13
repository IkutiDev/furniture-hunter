extends Control


@export var crafting_menu : Control
@export var open_menu_button : BaseButton

@export var recipes_go_here : Control
@export var crafting_recipe_scene : PackedScene



func _ready() -> void:
	open_menu_button.pressed.connect(_toggle_auctions_menu)

	
func _toggle_auctions_menu() -> void:
	crafting_menu.visible = !crafting_menu.visible


func load_recepies():
	# go through collection types
	#CollectionSet.Types
	# for each type of collection add a thing
	# then find the corresponding items that make the thing
	
	pass
