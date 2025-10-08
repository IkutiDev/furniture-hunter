extends Node3D


var exit_location : Vector3 # cusotmer will go here once they want to leave the shop

var entrance_location : Vector3 # the first spot inside the shop after the door

var visited_points = PackedVector3Array()

@export var points_of_interest = PackedVector3Array()

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






func _on_think_i_chose_to_walk() -> void:
	if points_of_interest.is_empty():
		energy = 0
		$StateMachine.transition_to("Think",[])
		return
	var going_to = points_of_interest[randi()%points_of_interest.size()]
	points_of_interest.erase(going_to)
	
	set_target_position(going_to)
	energy -= 15
	$StateMachine.transition_to("Walk")
	pass # Replace with function body.


func _on_think_i_chose_to_leave() -> void:

	set_target_position(exit_location)
	$StateMachine.transition_to("Walk")
	pass # Replace with function body.


func _on_think_i_chose_to_buy() -> void:
	var objects_seen = $LookingEyes.get_overlapping_areas()
	if objects_seen.is_empty():
		print("I want to buy, but I dont see anything!")
		return
		
	var the_shelf = objects_seen[0]
	var item_list = the_shelf.stored_items.duplicate() as Dictionary
	
	if item_list.is_empty():
		print("I want to buy an item from a thing, but the thing has no items!")
		energy -= 15
		$StateMachine.transition_to("Think",["nothing to buy"])
		return
	
	var selected_item = item_list.keys()[randi()%item_list.keys().size()]
	var items_price = item_list[selected_item]
	
	if items_price > money:
		print("I want to buy an ",selected_item ,", but I cant afford it!")
		$StateMachine.transition_to("Think",["buy failed"])
		energy -= 10
		return
	else:
		money -= items_price
		PlayerInventory.earn_money(items_price)
		the_shelf.remove_item(selected_item)
		print("I bought a ", selected_item,", I now have only this much money: ", money)
		$StateMachine.transition_to("Idle",[1.5])
	
	pass # Replace with function body.


func _on_think_i_chose_to_browse() -> void:
	var objects_seen = $LookingEyes.get_overlapping_areas()
	if objects_seen.is_empty():
		print("I wanted to browse, but I dont see anything!")
		return
		
	var the_shelf = objects_seen[0]
	var item_list = the_shelf.stored_items.duplicate() as Dictionary
	
	if item_list.is_empty():
		print("Silly me! I wanted to browse, but there are no items!")
		energy -= 10
		$StateMachine.transition_to("Think",["nothing to buy"])
		return
	energy -= 5
	$StateMachine.transition_to("Idle",[3.0])
			#
	pass # Replace with function body.
