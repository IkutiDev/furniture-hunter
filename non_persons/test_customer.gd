class_name Customer
extends Node3D


var exit_location : Vector3 # cusotmer will go here once they want to leave the shop

var entrance_location : Vector3 # the first spot inside the shop after the door

var visited_points = PackedVector3Array()

var haggle_scene = preload("res://non_persons/haggle_anker.tscn")

var i_want_to_buy_this

@export var objects_set_to_be_sold : Array[Node3D]

@export var preferences : Dictionary

@export var walk_speed = 2.0

@export var money = 100

@export var energy = 100.0

@export var customer_data : CustomerData

func _ready() -> void:

	$MeshInstance3D.mesh.material.albedo_color = Color(0.5 + randf() * 0.5,0.5 + randf() * 0.5 ,0.5 + randf() * 0.5) # random color for testing

	set_target_position(entrance_location)


func load_customer(data : CustomerData):
	money = data.starting_money
	preferences = data.purchase_preferences.duplicate()
	exit_location = data.exit_location
	entrance_location = data.entrance_location
	walk_speed = data.walk_speed
	customer_data = data
	pass


func _physics_process(delta):
	$EnergyBar.scale.x = energy/100.0
	if $NavigationAgent3D.is_navigation_finished():
		return
	var next_position = $NavigationAgent3D.get_next_path_position()
	var offset = next_position - global_position
	global_position = global_position.move_toward(next_position, delta * walk_speed)
	
	# makes the character look forward
	offset.y = 0
	look_at(global_position + offset, Vector3.UP)
	
	
	
func set_target_position(target_position: Vector3):
	$NavigationAgent3D.set_target_position(target_position)
	var start_position := global_transform.origin
	var optimize := true
	var navigation_map := get_world_3d().get_navigation_map()
	var path := NavigationServer3D.map_get_path(
			navigation_map,
			start_position,
			target_position,
			optimize)


func what_do_i_see() -> Array[Variant]:
	var objects_seen = $LookingEyes.get_overlapping_bodies()
	if objects_seen.is_empty():
		return []
	return objects_seen

func check_offer_quality(item_price : int, perfect_price: int) -> String: 
	if item_price > 2 * money:
		return "bad offer"
	
	var desire_to_buy = randi_range(-40,80) # this will need to be expanded later
	
	if item_price > desire_to_buy + perfect_price * 2:
		return "bad offer"
	elif item_price > desire_to_buy + perfect_price:
		return "weak offer" 
	else:
		return "great offer"

func _on_think_i_chose_to_walk() -> void:
	
	var points_of_interest : PackedVector3Array
	for thing in objects_set_to_be_sold:
		if thing == null:
			continue
		points_of_interest.push_back(thing.global_position)
	if points_of_interest.is_empty():
		energy = 0.0
		print("Oh what a tragedy! There are no things to be bought!")
		$StateMachine.transition_to("Think",[])
		return
	for point in visited_points:
		points_of_interest.erase(point)
	if points_of_interest.is_empty():
		energy = 0.0
		print("I have seen everything to be seen!")
		$StateMachine.transition_to("Think",[])
		return
	var going_to = points_of_interest[randi()%points_of_interest.size()]
	visited_points.push_back(going_to)
	print("I shall walk to ",going_to," next!")
	set_target_position(going_to)
	energy -= 15
	$StateMachine.transition_to("Walk")
	pass # Replace with function body.


func _on_think_i_chose_to_leave() -> void:

	set_target_position(exit_location)
	$StateMachine.transition_to("Walk")
	pass # Replace with function body.


func _on_think_i_chose_to_buy() -> void:
		
	if !is_instance_valid(i_want_to_buy_this):
		print("the thing i wanted to buy does not exist!")
		return
	var items_price = i_want_to_buy_this.current_price

		
	
	if items_price < 0:
		print("I want to buy an ",i_want_to_buy_this ,", but it's not for sale!")
		$StateMachine.transition_to("Think",["nothing to buy"])
		energy -= 5
		return
	
	if items_price > money:
		print("I want to buy an ",i_want_to_buy_this ,", but I cant afford it!")
		$StateMachine.transition_to("Think",["buy failed"])
		energy -= 10
		return
	else:
		i_want_to_buy_this.sold(items_price)
		money -= items_price

		
		print("I bought a ", i_want_to_buy_this,", I now have only this much money: ", money)
		$StateMachine.transition_to("Think",["buy sucesful"])
	
	pass # Replace with function body.


func _on_think_i_chose_to_browse() -> void:
	
	# check what is front of NPC
	
	
	var objects_seen = what_do_i_see()
	if objects_seen.size() == 0:
		print("I want to buy, but I dont see anything!")
		$StateMachine.transition_to("Think",["nothing to buy"])
		return

	# drop if everything in sight has a price less than 1
	
	
	var valid_things = []
	
	for object in objects_seen:
		var object_parent = object.get_parent()
		if object_parent is FurnitureInstance or object_parent is ItemInstance:
			if object_parent.current_price > 0 :
				valid_things.append(object_parent)

	if valid_things.is_empty():
		print("none of the objects witnessed are for sale")
		$StateMachine.transition_to("Think",["nothing to buy"])
		energy -= 5
		return
	$StateMachine.transition_to("Idle",[2.5])
	await $StateMachine/Idle.idle_complete
	
	# mark thing as i_want_to_buy_this
	
	i_want_to_buy_this = valid_things[randi()%valid_things.size()]
	
	# use check_offer_quality to asses if its a "great offer" / "weak offer" / "bad offer"
	
	if i_want_to_buy_this == null:
		$StateMachine.transition_to("Think",["nothing to buy"])
		# thing npc wanted to buy is null, so we exit earlier
		return

	var offer_quality = check_offer_quality(i_want_to_buy_this.current_price, i_want_to_buy_this.perfect_price) as String


	# go back to Think with result
	energy -= 5
	$StateMachine.transition_to("Think",[offer_quality])
	

			#
	pass # Replace with function body.


func _on_think_i_chose_to_haggle() -> void:

	var object_name : String # name of thing bought
	var object_price : int # starting price
	var offers : Array # a 1+ Array of offers
	

	
	if i_want_to_buy_this is FurnitureInstance:
		object_name = i_want_to_buy_this.furniture_data.object_name
		object_price = i_want_to_buy_this.current_price

	if i_want_to_buy_this is ItemInstance:
		if i_want_to_buy_this.item_data == null:
			# can't haggle on item that doesn't exist
			return
		object_name = i_want_to_buy_this.item_data.object_name
		object_price = i_want_to_buy_this.current_price


	var offer_range = randi_range(1,5)
	var bottom = (object_price/2) + randi_range(5,15) # lowest offer
	var next_offer = bottom
	for offer in offer_range:
		offers.push_back(next_offer)
		next_offer += int( (object_price - next_offer) / 2.0) - offer_range # increase next offer by half distance between starting price and current offer


	var haggle_node = haggle_scene.instantiate() as Node3D
	haggle_node.global_position = global_position
	haggle_node.load_haggle_data(i_want_to_buy_this,object_name,object_price,offers)
	get_parent().add_child(haggle_node)
	$StateMachine.transition_to("Haggle",[haggle_node])
	
	pass # Replace with function body.
