class_name SpecialDealLootbox
extends RefCounted

const BID_INCREASE : int = 50

var lootbox_data : LootboxData
var deal_time : float
var highest_bidder_entity : BidderEntity = null
var highest_bid : int
var player_bid : int = 0
func _init(data : LootboxData, time : float) -> void:
	lootbox_data = data
	deal_time = time
	highest_bid = lootbox_data.lootbox_price
