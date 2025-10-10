extends Node3D





func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "new_animation":
		pass
		#$Sprite3D.visible = false
	pass # Replace with function body.


#func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#if event.is_class("InputEventMouseMotion"):
		#print("event_position: ",event_position," / event_position * global_rotation:", $MeshInstance3D/StaticBody3D.global_rotation)
		#
	#pass # Replace with function body.



func _on_no_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		$SubViewport/HaggleWorld/VBoxContainer/NoDeal.grab_focus()
	if event.is_action_pressed("press"):
		print("NO DEAL")
	pass # Replace with function body.


func _on_deal_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_class("InputEventMouseMotion"):
		$SubViewport/HaggleWorld/VBoxContainer/Deal.grab_focus()
	if event.is_action_pressed("press"):
		print("DEAL")
	pass # Replace with function body.




func _on_no_deal_mouse_exited() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/NoDeal.release_focus()
	pass # Replace with function body.


func _on_deal_mouse_exited() -> void:
	$SubViewport/HaggleWorld/VBoxContainer/Deal.release_focus()
	pass # Replace with function body.
