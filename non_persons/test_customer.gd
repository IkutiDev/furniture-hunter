extends Node3D


var exit_location : Vector3 # cusotmer will go here once they want to leave the shop

var entrance_location : Vector3 # the first spot inside the shop after the door

var visited_points = PackedVector3Array()

@export var objects_set_to_be_sold : Array[Node3D]

@export var character_speed = 2.0

@export var money = 100

@export var energy = 100.0

func _ready() -> void:

	$MeshInstance3D.mesh.material.albedo_color = Color(0.5 + randf() * 0.5,0.5 + randf() * 0.5 ,0.5 + randf() * 0.5) # random color for testing

	set_target_position(entrance_location)



func _physics_process(delta):
	$EnergyBar.scale.x = energy/100.0
	if $NavigationAgent3D.is_navigation_finished():
		return
	var next_position = $NavigationAgent3D.get_next_path_position()
	var offset = next_position - global_position
	global_position = global_position.move_toward(next_position, delta * character_speed)
	
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



func _on_think_i_chose_to_walk() -> void:
	
	var points_of_interest : PackedVector3Array
	for thing in objects_set_to_be_sold:
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
	var objects_seen = what_do_i_see()
	
	
	if objects_seen.size() == 0:
		print("I want to buy, but I dont see anything!")
		$StateMachine.transition_to("Think",["nothing to buy"])
		energy -= 15
		return
	
	var thing_to_buy
	var optional_index
	var items_price = -1
	var object_seen

	for o in objects_seen:
		object_seen = o.get_parent()
		if object_seen is FurnitureInstance or object_seen is ItemInstance:
			if object_seen.current_price < 0:
				continue
			items_price = object_seen.current_price
			thing_to_buy = object_seen
			break
		
		
	#if object_seen is FurnitureContainerInstance:
		#var items_in_container = object_seen.item_slots as Array[ItemSlot]
		#if items_in_container.is_empty():
#
			#print("I want to buy an item from ",object_seen ,", but there are no items on it!")
			#$StateMachine.transition_to("Think",["nothing to buy"])
			#energy -= 5
			#return
		#else:
			#var selected_item_slot_index = randi()%items_in_container.size() 
			#var selected_item_slot = items_in_container[selected_item_slot_index] as ItemSlot
			#items_price = selected_item_slot.current_price
			#thing_to_buy = selected_item_slot.item_data
			#optional_index = selected_item_slot_index
#
	#elif object_seen is FurnitureInstance:
		#items_price = object_seen.current_price
		#thing_to_buy = object_seen
	#if item_list.is_empty():
		#print("I want to buy an item from a thing, but the thing has no items!")
		#energy -= 15
		#$StateMachine.transition_to("Think",["nothing to buy"])
		#return
	

	
	if items_price < 0:
		print("I want to buy an ",thing_to_buy ,", but it's not for sale!")
		$StateMachine.transition_to("Think",["nothing to buy"])
		energy -= 5
		return
	
	if items_price > money:
		print("I want to buy an ",thing_to_buy ,", but I cant afford it!")
		$StateMachine.transition_to("Think",["buy failed"])
		energy -= 10
		return
	else:
		if thing_to_buy != null:
			thing_to_buy.sold()
			money -= items_price

		
		print("I bought a ", thing_to_buy,", I now have only this much money: ", money)
		$StateMachine.transition_to("Idle",[1.5])
	
	pass # Replace with function body.


func _on_think_i_chose_to_browse() -> void:
	
	var objects_seen = what_do_i_see()
	if objects_seen.size() == 0:
		print("I want to buy, but I dont see anything!")
		$StateMachine.transition_to("Think",["nothing to buy"])
		return
	else:
		print(objects_seen.size())
		
	
	var items_price = -1
	
	for o in objects_seen:
		var object_parent = o.get_parent()
		if object_parent is FurnitureInstance or object_parent is ItemInstance:
			items_price = object_parent.current_price
			print(items_price)
			if items_price > 0:
				print(object_parent.current_price)
				energy -= 5
				$StateMachine.transition_to("Idle",[1.0 + randf()*2.0])
				return
				
	#print("I want to browse ",object_seen ,", but it's not for sale since it's ", items_price)
	print("none of the objects witnessed are for sale")
	$StateMachine.transition_to("Think",["nothing to buy"])
	energy -= 5
	#if object_seen is FurnitureContainerInstance:
		#var items_in_container = object_seen.item_slots as Array[ItemSlot]
		#if items_in_container.is_empty():
			#items_price = -1
		#else:
			#
			#var random_item = items_in_container[randi()%items_in_container.size()] as ItemSlot
			#items_price = random_item.current_price
		
	
	#if item_list.is_empty():
		#print("Silly me! I wanted to browse, but there are no items!")
		#energy -= 10
		#$StateMachine.transition_to("Think",["nothing to buy"])
		#return
	
	
			#
	pass # Replace with function body.
