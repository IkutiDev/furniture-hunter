extends Node
@export var lootboxes : Array[LootboxData]
@export var special_lootboxes : Array[LootboxData]
@export var new_deal_cooldown : float
@export var entities_bidding_cooldown : float
@export var player_bidder_entity: BidderEntity
@export var other_bidder_entities : Array[BidderEntity]
var current_special_deals : Array[SpecialDealLootbox]

var current_cooldown = 0.0
var current_entities_bidding_cooldown = 0.0
var current_bidders : Array[BidderEntity]

func _process(delta: float) -> void:
	for i in range(current_special_deals.size() - 1, -1, -1):
		if current_special_deals[i].deal_time <= 0:
			if current_special_deals[i].highest_bidder_entity  == null:
				pass
			elif current_special_deals[i].highest_bidder_entity == player_bidder_entity:
				PlayerInventory.add_object_to_inventory(current_special_deals[i].lootbox_data)
			else:
				PlayerInventory.earn_money(current_special_deals[i].player_bid)
			current_special_deals.remove_at(i)
			EventBus.update_auctions_ui.emit()
		current_special_deals[i].deal_time -= delta
	
	current_cooldown += delta
	current_entities_bidding_cooldown += delta
	if new_deal_cooldown <= current_cooldown:
		current_cooldown = 0.0
		try_spawn_special_deal()
	if entities_bidding_cooldown <= current_entities_bidding_cooldown:
		current_entities_bidding_cooldown = 0.0
		try_to_bid()
	
func try_spawn_special_deal() -> void:
	for l in AuctionManager.special_lootboxes:
		if l.renown_required <= PlayerInventory.renown:
			var random = randi_range(0, 100)
			if l.special_deal_spawn_chance <= random:
				current_special_deals.append(SpecialDealLootbox.new(l, randf_range(l.special_deal_time_min, l.special_deal_time_max)))

func try_to_bid() -> void:
	current_bidders = other_bidder_entities.duplicate()
	current_bidders.shuffle()
	for i in range(current_bidders.size() - 1, -1, -1):
		for d in current_special_deals:
			if d.deal_time <= 10.0:
				continue
			if d.highest_bid <= current_bidders[i].max_bid:
				var will_bid : bool = 1 == randi_range(0,3)
				if will_bid:
					d.highest_bidder_entity = current_bidders[i]
					d.highest_bid = d.highest_bid + d.BID_INCREASE
				current_bidders.remove_at(i)
				break
