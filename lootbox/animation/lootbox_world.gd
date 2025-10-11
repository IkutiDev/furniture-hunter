extends Node3D

signal animation_complete

func play():
	$MainAnimation.play("OpenDoor")


func _on_main_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "OpenDoor":
		animation_complete.emit()
	pass # Replace with function body.
