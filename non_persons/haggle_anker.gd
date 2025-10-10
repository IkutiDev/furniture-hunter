extends Node3D

@export var haggle_time_left = 8.0

signal haggle_resolved(result)

func _ready() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/ProgressBar.max_value = haggle_time_left

func _process(delta: float) -> void:
	if haggle_time_left < 0.1:
		haggle_time_out()
		
	haggle_time_left -= delta
	$SubViewport/HaggleWorld/VBoxContainer/ProgressBar.value = haggle_time_left
	

func haggle_time_out():
	haggle_resolved.emit("time_out")
	queue_free()
	pass


func haggle_agree():
	haggle_resolved.emit("agree")
	pass


func haggle_refuse():
	haggle_resolved.emit("refuse")
	pass

func load_haggle_data(data):
	# needs to extract relevant details like price

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
