extends Node3D

var customer_scene = preload("res://non_persons/test_customer.tscn")

## defaults to "get_tree().current_scene" if non provided
@export var where_to_plonk_customers : Node3D

var desired_customer_count = 0

@export var max_customer_count = 5 

var objects_set_to_be_sold : Array[Node3D]

var _customer_count = 0

var is_day = false

func _ready() -> void:
	
	if where_to_plonk_customers == null:
		where_to_plonk_customers = get_tree().current_scene
		
	EventBus.start_day.connect(start_day)
	EventBus.end_day.connect(end_day)
	EventBus.set_price.connect(add_object_to_collection)
	EventBus.object_sold.connect(remove_object_from_collection)
	

func add_object_to_collection(instance : Node3D) -> void:
	objects_set_to_be_sold.append(instance)

func remove_object_from_collection(instance : Node3D) -> void:
	objects_set_to_be_sold.erase(instance)

func start_day():
	$DayToggle/DayIndicator.mesh.material.albedo_color = Color("yellow")
	is_day = true
	desired_customer_count = max_customer_count
	pass

func end_day():
	$DayToggle/DayIndicator.mesh.material.albedo_color = Color("dark blue")
	desired_customer_count = 0
	for cusomter in get_tree().get_nodes_in_group("Customer"):
		cusomter.energy -= 80
	is_day = false
	if _customer_count == desired_customer_count:
		GameManager.set_game_state(GameManager.GameState.NIGHT)
	pass

func spawn_customer() -> void:
	var new_customer = customer_scene.instantiate() as Node3D
	new_customer.global_position = $SpawnPoint.global_position
	new_customer.exit_location = $TheAreaThatEatsPeople.global_position
	new_customer.entrance_location = $ShopEntrance.global_position
	new_customer.objects_set_to_be_sold = objects_set_to_be_sold
	where_to_plonk_customers.add_child(new_customer)
	_customer_count += 1
	pass
	

func de_spawn_customer(customer : Node3D) -> void:
	_customer_count -= 1
	customer.queue_free()
	if is_instance_valid(customer):
		await customer.tree_exited
	if _customer_count == 0 and GameManager.game_state == GameManager.GameState.ENDING_DAY:
		assert(_customer_count == get_tree().get_nodes_in_group("Customer").size())
		GameManager.set_game_state(GameManager.GameState.NIGHT)

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


func _on_day_toggle_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("press"):
		if is_day:
			end_day()
		else:
			start_day()
	pass # Replace with function body.
