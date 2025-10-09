extends Node3D


func change_shown_object(new_object : Node3D) -> void:
	$ObjectHolder.get_child(0).queue_free()
	$ObjectHolder.add_child(new_object)
