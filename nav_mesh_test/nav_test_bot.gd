extends Node3D

var points_of_interest = []

@export var character_speed := 10.0

@onready var _nav_agent := $NavigationAgent3D as NavigationAgent3D

func _ready() -> void:
	
	$MeshInstance3D.mesh.material.albedo_color = Color(randf(),randf(),randf()) # random color for testing




func _physics_process(delta):
	if _nav_agent.is_navigation_finished():
		return
	var next_position := _nav_agent.get_next_path_position()
	var offset := next_position - global_position
	global_position = global_position.move_toward(next_position, delta * character_speed)

	# Make the robot look at the direction we're traveling.
	# Clamp y to 0 so the robot only looks left and right, not up/down.
	offset.y = 0
	look_at(global_position + offset, Vector3.UP)

func set_target_position(target_position: Vector3):
	_nav_agent.set_target_position(target_position)
	# Get a full navigation path with the NavigationServer API.

	var start_position := global_transform.origin
	var optimize := true
	var navigation_map := get_world_3d().get_navigation_map()
	var path := NavigationServer3D.map_get_path(
			navigation_map,
			start_position,
			target_position,
			optimize)
		#_nav_path_line.draw_path(path)


func _on_go_place_timer_timeout() -> void:
	$GoPlaceTimer.wait_time = max(3, $GoPlaceTimer.wait_time + randf_range(-1,1))
	if points_of_interest.size() > 0:
		set_target_position(points_of_interest[randi()%points_of_interest.size()])
	pass # Replace with function body.
