class_name LootboxEntry
extends Control

@export var icon : TextureRect
@export var lootbox_title : Label
@export var lootbox_price : Label
@export var buy_button : BaseButton
@export_group("Special Deal")
@export var highest_bid_amount_label : Label
@export var highest_bidder_label : Label
@export var player_bid_amount_label : Label
@export var time_label : Label

var lootbox_data : LootboxData

var default_price_label_color : Color

var special_deal_data : SpecialDealLootbox = null

func _ready() -> void:
	buy_button.pressed.connect(lootbox_button_pressed)
	default_price_label_color = lootbox_price.get_theme_color("font_color")

func set_data(data : LootboxData, _special_deal_data : SpecialDealLootbox = null) -> void:
	lootbox_data = data
	icon.texture = data.icon
	lootbox_title.text = data.lootbox_title
	lootbox_price.text = str(data.lootbox_price)
	special_deal_data = _special_deal_data

func lootbox_button_pressed() -> void:
	if special_deal_data != null:
		var bid_amount = special_deal_data.highest_bid - special_deal_data.player_bid + special_deal_data.BID_INCREASE
		if PlayerInventory.spend_money(bid_amount) :
			special_deal_data.highest_bid = bid_amount
			special_deal_data.highest_bidder_entity = AuctionManager.player_bidder_entity
			special_deal_data.player_bid = bid_amount
	elif lootbox_data != null:
		if PlayerInventory.spend_money(lootbox_data.lootbox_price):
			PlayerInventory.add_object_to_inventory(lootbox_data)
		
func _process(delta: float) -> void:
	if lootbox_data != null:
		if lootbox_data.lootbox_price > PlayerInventory.money:
			lootbox_price.add_theme_color_override("font_color", Color.RED)
		else:
			lootbox_price.add_theme_color_override("font_color", default_price_label_color)
	
	if special_deal_data != null:
		time_label.text = "Time left: "+str(special_deal_data.deal_time as int)
		if special_deal_data.highest_bidder_entity == null:
			highest_bidder_label.text = ""
			highest_bid_amount_label.text = "Start bid: "+str(special_deal_data.highest_bid)+"$"
		else:
			highest_bidder_label.text = "by" + special_deal_data.highest_bidder_entity.name
			highest_bid_amount_label.text = "Highest bid: "+str(special_deal_data.highest_bid)+"$"
		player_bid_amount_label.text = "Your bid: "+ str(special_deal_data.player_bid)+"$"
		
		
		
