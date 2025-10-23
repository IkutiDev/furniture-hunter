class_name LootboxEntry
extends Control

@export var icon : TextureRect
@export var lootbox_title : Label
@export var lootbox_price : Label
@export var buy_button : BaseButton

@export_group("Special Deal")
@export var highest_bid_amount_label : Label
@export var player_bid_amount_label : Label
@export var time_label : Label
@export var claim_button : BaseButton
@export var bid_button_section : Control
@export var claim_button_section : Control

var lootbox_data : LootboxData

var default_price_label_color : Color

var special_deal_data : SpecialDealLootbox = null

func _ready() -> void:
	buy_button.pressed.connect(lootbox_button_pressed)
	if claim_button != null:
		claim_button.pressed.connect(claim_special_lootbox)
	default_price_label_color = lootbox_price.get_theme_color("font_color")

func set_data(data : LootboxData, _special_deal_data : SpecialDealLootbox = null) -> void:
	lootbox_data = data
	icon.texture = data.icon
	lootbox_title.text = data.lootbox_title
	if lootbox_price != null:
		lootbox_price.text = str(data.lootbox_price)
	special_deal_data = _special_deal_data

func lootbox_button_pressed() -> void:
	if special_deal_data != null:
		var bid_amount = special_deal_data.highest_bid + special_deal_data.BID_INCREASE
		if PlayerInventory.spend_money(bid_amount):
			special_deal_data.highest_bid = bid_amount
			special_deal_data.player_bid = bid_amount
	elif lootbox_data != null:
		if PlayerInventory.spend_money(lootbox_data.lootbox_price):
			PlayerInventory.add_object_to_inventory(lootbox_data)
		
func _process(delta: float) -> void:
	if lootbox_data != null and lootbox_price != null:
		if lootbox_data.lootbox_price > PlayerInventory.money:
			lootbox_price.add_theme_color_override("font_color", Color.RED)
		else:
			lootbox_price.add_theme_color_override("font_color", default_price_label_color)
	
	if special_deal_data != null:
		if special_deal_data.deal_time <= 0:
			time_label.text = "END"
			time_label.add_theme_color_override("font_color", Color.RED)
		else:
			time_label.text = str(special_deal_data.deal_time as int) + " s"
			time_label.add_theme_color_override("font_color", Color.BLACK)
		highest_bid_amount_label.text = str(special_deal_data.highest_bid)
		player_bid_amount_label.text = str(special_deal_data.player_bid)
		if special_deal_data.highest_bid > special_deal_data.player_bid:
			lootbox_price.add_theme_color_override("font_color", Color.RED)
		else:
			lootbox_price.add_theme_color_override("font_color", Color.WEB_GREEN)
		if special_deal_data.for_player_claim:
			bid_button_section.hide()
			claim_button_section.show()
		elif not bid_button_section.visible:
			bid_button_section.show()
			claim_button_section.hide()
	
func claim_special_lootbox() -> void:
	AuctionManager.current_special_deals.erase(special_deal_data)
	PlayerInventory.add_object_to_inventory(lootbox_data)
	EventBus.update_auctions_ui.emit()
		
