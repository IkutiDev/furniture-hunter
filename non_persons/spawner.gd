extends Node3D

var customer_scene = preload("res://non_persons/test_customer.tscn")

## defaults to "get_tree().current_scene" if non provided
@export var where_to_plonk_customers : Node3D

@export var desired_customer_count = 5 

@export var points_of_interest : PackedVector3Array

var _customer_count = 0

func _ready() -> void:
	
	if where_to_plonk_customers == null:
		where_to_plonk_customers = get_tree().current_scene
	

func end_day():
	desired_customer_count = 0
	for cusomter in get_tree().get_nodes_in_group("Customer"):
		cusomter.energy -= 80
	pass

func spawn_customer() -> void:
	var new_customer = customer_scene.instantiate() as Node3D
	new_customer.global_position = $SpawnPoint.global_position
	new_customer.exit_location = $TheAreaThatEatsPeople.global_position
	new_customer.entrance_location = $ShopEntrance.global_position
	new_customer.points_of_interest = points_of_interest.duplicate()
	where_to_plonk_customers.add_child(new_customer)
	_customer_count += 1
	pass
	

func de_spawn_customer(customer : Node3D) -> void:
	_customer_count -= 1
	customer.queue_free()
	pass


func _on_the_area_that_eats_people_area_entered(area: Area3D) -> void:
	if area.is_in_group("Customer"):
		de_spawn_customer(area)
	pass # Replace with function body.


func _on_spawn_timer_timeout() -> void:
	if _customer_count >= desired_customer_count:
		return
	if randf() > 0.47:
		spawn_customer()

	pass # Replace with function body.
