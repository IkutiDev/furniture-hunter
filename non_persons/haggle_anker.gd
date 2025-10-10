extends Node3D

@export var haggle_time_left = 8.0

signal haggle_resolved(result)

var object_being_haggled

var counter_offers = []

var current_offer = -1

var accepted_price = -1

func _ready() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/ProgressBar.max_value = haggle_time_left

func _process(delta: float) -> void:
	if haggle_time_left < 0.1:
		haggle_time_out()
		
	haggle_time_left -= delta
	$SubViewport/HaggleWorld/VBoxContainer/ProgressBar.value = haggle_time_left
	

func haggle_time_out():
	haggle_resolved.emit("time_out")

	pass


func haggle_agree():

	object_being_haggled.sold(current_offer)
	haggle_resolved.emit("agree")

	pass


func haggle_refuse():
	if load_next_counter_offer():
		haggle_time_left = min(haggle_time_left + 2.0, 8.0)
		return
	haggle_resolved.emit("refuse")

	pass

func load_haggle_data(thing_haggled : Node3D, object_name : String, starting_price : int, offers : Array):
	object_being_haggled = thing_haggled
	$SubViewport/HaggleWorld/VBoxContainer/ObjectName.text = object_name
	$SubViewport/HaggleWorld/VBoxContainer/StartingPrice.text = "Starting price:\n" + str(starting_price)
	counter_offers = offers.duplicate()
	load_next_counter_offer()

	pass

func load_next_counter_offer() -> bool:
	if counter_offers.is_empty():
		return false
	else:
		current_offer = counter_offers.pop_front()
		$SubViewport/HaggleWorld/VBoxContainer/CounterOffer.text = "Counter offer:\n" + str(current_offer)
		return true
	pass

#func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#if event.is_class("InputEventMouseMotion"):
		#print("event_position: ",event_position," / event_position * global_rotation:", $MeshInstance3D/StaticBody3D.global_rotation)
		#
	#pass # Replace with function body.



func _on_no_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		$SubViewport/HaggleWorld/VBoxContainer/NoDeal.grab_focus()
	if event.is_action_pressed("press"):
		haggle_refuse()
	pass # Replace with function body.


func _on_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		$SubViewport/HaggleWorld/VBoxContainer/Deal.grab_focus()
	if event.is_action_pressed("press"):
		haggle_agree()
	pass # Replace with function body.




func _on_no_deal_mouse_exited() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/NoDeal.release_focus()
	pass # Replace with function body.


func _on_deal_mouse_exited() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/Deal.release_focus()
	pass # Replace with function body.
