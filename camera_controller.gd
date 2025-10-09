extends Node3D

@export var limit_x : Vector2
@export var limit_z : Vector2
@export var speed : float = 100

func _process(delta: float) -> void:
	var move_vector = Input.get_vector("right", "left", "down", "up")
	var move_delta = position + Vector3(move_vector.x, 0, move_vector.y) * speed * delta * global_transform.basis
	if move_delta.x > limit_x.x:
		move_delta.x = limit_x.x
	if move_delta.x < limit_x.y:
		move_delta.x = limit_x.y
	if move_delta.z > limit_z.x:
		move_delta.z = limit_z.x
	if move_delta.z < limit_z.y:
		move_delta.z = limit_z.y
	position = move_delta
