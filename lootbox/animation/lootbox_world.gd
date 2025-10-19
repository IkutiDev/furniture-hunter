extends Node3D

signal animation_complete

func play():
	$MainAnimation.play("OpenDoor")

func early_end():
	if $MainAnimation.is_playing():
		$MainAnimation.seek($MainAnimation.current_animation_length)
		animation_complete.emit()

func _on_main_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "OpenDoor":
		animation_complete.emit()
	pass # Replace with function body.
