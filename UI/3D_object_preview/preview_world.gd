extends Node3D


func change_shown_object(new_object_mesh : Mesh) -> void:
	$ObjectHolder/ShownObject.mesh = new_object_mesh
