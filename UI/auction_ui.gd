class_name AuctionUI
extends Control

@export var auctions_menu : Control
@export var open_menu_button : BaseButton
@export var lootbox_buttons_container : Control
@export var default_stock_label : Label
@export var special_deal_label : Label
@export var empty_special_deals : Label
@export var lootbox_buy_button_scene : PackedScene
@export var lootbox_special_deal_button_scene : PackedScene

func _ready() -> void:
	open_menu_button.pressed.connect(_toggle_auctions_menu)
	EventBus.update_auctions_ui.connect(_update_auctions_menu)
	
func _toggle_auctions_menu() -> void:
	auctions_menu.visible = !auctions_menu.visible
	if auctions_menu.visible:
		_update_auctions_menu()

	

func _update_auctions_menu() -> void:
	var children = lootbox_buttons_container.get_children()
	empty_special_deals.show()
	for c in children:
		if c is LootboxEntry:
			c.queue_free()
	for l in AuctionManager.lootboxes:
		if l.renown_required <= PlayerInventory.renown:
			var button_instance := lootbox_buy_button_scene.instantiate() as LootboxEntry
			button_instance.set_data(l)
			default_stock_label.add_sibling(button_instance)
	for l in AuctionManager.current_special_deals:
		if l.lootbox_data.renown_required <= PlayerInventory.renown:
			var button_instance := lootbox_special_deal_button_scene.instantiate() as LootboxEntry
			button_instance.set_data(l.lootbox_data, l)
			special_deal_label.add_sibling(button_instance)
			empty_special_deals.hide()
