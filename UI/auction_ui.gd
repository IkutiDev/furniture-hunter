class_name AuctionUI
extends Control

@export var auctions_menu : Control
@export var open_menu_button : BaseButton
@export var lootbox_buttons_container : Control
@export var lootbox_buy_button_scene : PackedScene

func _ready() -> void:
	open_menu_button.pressed.connect(_toggle_auctions_menu)
	
func _toggle_auctions_menu() -> void:
	auctions_menu.visible = !auctions_menu.visible
	if auctions_menu.visible:
		var children = lootbox_buttons_container.get_children()
		for c in children:
			c.queue_free()
		for l in AuctionManager.lootboxes:
			var button_instance := lootbox_buy_button_scene.instantiate() as LootboxEntry
			button_instance.set_data(l)
			lootbox_buttons_container.add_child(button_instance)
