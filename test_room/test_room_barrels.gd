extends Node3D

var barrel_scene = preload("res://test_room/test_barrel.tscn")


func _ready() -> void:
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()
	spawn_barrel()

func spawn_barrel():
	var spawn_location = $SpawnPoint.global_position + Vector3(randi_range(-4,4),0,randi_range(-4,4))
	var new_barrel = barrel_scene.instantiate() as Node3D
	new_barrel.global_position = spawn_location
	new_barrel.connect("tree_exited",Callable(self,"spawn_barrel"))
	add_child(new_barrel)
	pass
