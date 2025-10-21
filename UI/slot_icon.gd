extends NinePatchRect

@export_enum("Common:0", "Uncommon:1", "Rare:2", "Legendary:3") var rarity : int

var slot_texture = {
	0 : load("res://UI/UI_kasia/items_down_menu/background_common_item.png"),
	1 : load("res://UI/UI_kasia/items_down_menu/background_rare_item.png"),
	2 : load("res://UI/UI_kasia/items_down_menu/background_superrare_item.png"),
	3 : load("res://UI/UI_kasia/items_down_menu/background_legendary_item.png")
}

func set_rarity(new_rarity : int):
	rarity = new_rarity
	texture = slot_texture[rarity]
	pass
