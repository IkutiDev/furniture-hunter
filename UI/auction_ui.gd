class_name AuctionUI
extends Control

enum ActiveWindowType { OWNED, SHOP, AUCTIONS}

@export var key_button_scene : PackedScene
@export var lootbox_buy_button_scene : PackedScene
@export var lootbox_special_deal_button_scene : PackedScene

@export var close_button : BaseButton
@export var owned_button : TextureButton
@export var shop_button : TextureButton
@export var auctions_button : TextureButton

@export var owned_section : Control
@export var owned_list : Control
@export var shop_section : Control
@export var shop_list : Control
@export var auctions_section : Control
@export var auctions_list : Control

@export var active_button_texture : Texture2D
@export var inactive_button_texture : Texture2D

var active_window_type : ActiveWindowType = ActiveWindowType.SHOP

func _ready() -> void:
	EventBus.update_auctions_ui.connect(_update_auctions_menu)
	close_button.pressed.connect(close_menu)
	owned_button.pressed.connect(open_owned)
	shop_button.pressed.connect(open_shop)
	auctions_button.pressed.connect(open_auctions)
	update_current_window_type()
	
	
func open_owned() -> void:
	active_window_type = ActiveWindowType.OWNED
	update_current_window_type()

func open_shop() -> void:
	active_window_type = ActiveWindowType.SHOP
	update_current_window_type()
	
func open_auctions() -> void:
	active_window_type = ActiveWindowType.AUCTIONS
	update_current_window_type()

func update_current_window_type() -> void:
	owned_section.hide()
	shop_section.hide()
	auctions_section.hide()
	
	owned_button.texture_normal = active_button_texture if active_window_type == ActiveWindowType.OWNED else inactive_button_texture
	shop_button.texture_normal = active_button_texture if active_window_type == ActiveWindowType.SHOP else inactive_button_texture
	auctions_button.texture_normal = active_button_texture if active_window_type == ActiveWindowType.AUCTIONS else inactive_button_texture
	
	match active_window_type:
		ActiveWindowType.OWNED:
			owned_section.show()
		ActiveWindowType.SHOP:
			shop_section.show()
		ActiveWindowType.OWNED:
			auctions_section.show()
			
	_update_auctions_menu()

func _toggle_auctions_menu() -> void:
	if visible:
		close_menu()
	else:
		open_menu()
	if visible:
		_update_auctions_menu()

func open_menu() -> void:
	_update_auctions_menu()
	show()
	EventBus.menu_open.emit(self)

func close_menu() -> void:
	hide()
	EventBus.menu_close.emit(self)


func _update_auctions_menu() -> void:
	var children = shop_list.get_children()
	for c in children:
		if c is LootboxEntry:
			c.queue_free()
	children = owned_list.get_children()
	for c in children:
		if c is LootboxButton:
			c.queue_free()
	children = auctions_list.get_children()
	for c in children:
		if c is LootboxEntry:
			c.queue_free()
	for l in PlayerInventory.lootboxes:
		var button_instance := key_button_scene.instantiate() as LootboxButton
		button_instance.set_data(l)
		owned_list.add_child(button_instance)
	for l in AuctionManager.lootboxes:
		if l.renown_required <= PlayerInventory.renown:
			var button_instance := lootbox_buy_button_scene.instantiate() as LootboxEntry
			button_instance.set_data(l)
			shop_list.add_child(button_instance)
	for l in AuctionManager.current_special_deals:
		if l.lootbox_data.renown_required <= PlayerInventory.renown:
			var button_instance := lootbox_special_deal_button_scene.instantiate() as LootboxEntry
			button_instance.set_data(l.lootbox_data, l)
			auctions_list.add_child(button_instance)
