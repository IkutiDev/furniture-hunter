extends Area3D


func _on_area_entered(_area: Area3D) -> void:
	get_parent().queue_free()
	pass # Replace with function body.
