extends Node3D

func _ready() -> void:
	var points_of_interest = PackedVector3Array()

	for point in $PointsOfInterest.get_children():
		points_of_interest.push_back(point.global_position)
	$Spawner.points_of_interest = points_of_interest
