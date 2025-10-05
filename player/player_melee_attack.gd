extends Node3D



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()

func attack():
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("new_animation")
	pass
