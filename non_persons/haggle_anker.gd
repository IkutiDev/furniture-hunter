extends Node3D

@export var haggle_time_left = 8.0

signal haggle_resolved(result)

var object_being_haggled

var counter_offers = []

var current_offer = -1

var accepted_price = -1

var object_data

@export var object_name_label : Label
@export var counter_offer_label : Label
@export var progess_bar : ProgressBar
@export var starting_price_label : Label
@export var deal_button : Button
@export var no_deal_button : Button

@export var object_button_goes_here : Control

@export var item_button_scene : PackedScene
@export var furniture_button_scene : PackedScene

func _ready() -> void:
	progess_bar.max_value = haggle_time_left

func _process(delta: float) -> void:
	if haggle_time_left < 0.1:
		haggle_time_out()
		
	haggle_time_left -= delta
	progess_bar.value = haggle_time_left
	
	if object_being_haggled == null:
		# object being haggled got bought by someone else. This should be the behaviour or we will change it so the object being haggled by npc 1 is "hogged" and can't be sold until this npc haggle is finished
		haggle_time_out()
	

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

func load_haggle_data(thing_haggled : Node3D, object_name : String, starting_price : int, offers : Array, data = null):
	object_being_haggled = thing_haggled
	object_name_label.text = object_name
	object_data = data
	starting_price_label.text = "Starting price:\n" + str(starting_price)
	counter_offers = offers.duplicate()
	var new_button
	if object_data is ItemData:
		new_button = item_button_scene.instantiate() as ItemButton
	if object_data is FurnitureData:
		new_button = furniture_button_scene.instantiate() as FurnitureButton
	new_button.set_data(object_data)
	object_button_goes_here.add_child(new_button)

	load_next_counter_offer()

	pass

func load_next_counter_offer() -> bool:
	if counter_offers.is_empty():
		return false
	else:
		current_offer = counter_offers.pop_front()
		counter_offer_label.text = "Counter offer:\n" + str(current_offer)
		return true
	pass

#func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#if event.is_class("InputEventMouseMotion"):
		#print("event_position: ",event_position," / event_position * global_rotation:", $MeshInstance3D/StaticBody3D.global_rotation)
		#
	#pass # Replace with function body.



func _on_no_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		no_deal_button.grab_focus()
	if event.is_action_pressed("press"):
		haggle_refuse()
	pass # Replace with function body.


func _on_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		deal_button.grab_focus()
	if event.is_action_pressed("press"):
		haggle_agree()
	pass # Replace with function body.




func _on_no_deal_mouse_exited() -> void:
	no_deal_button.release_focus()
	pass # Replace with function body.


func _on_deal_mouse_exited() -> void:
	deal_button.release_focus()
	pass # Replace with function body.
