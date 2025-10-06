extends Node3D



func _ready() -> void:
	var locations_of_interest = []
	for point in $PointsOfInterest.get_children():
		locations_of_interest.push_back(point.global_position)
	
	for bot in $TestBots.get_children():
		bot.points_of_interest = locations_of_interest.duplicate()
