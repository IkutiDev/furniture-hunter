extends Node3D

func _ready() -> void:

	print(Tags.get_tag_name(Tags.Types.EGYPT))
	pass
	#var points_of_interest = []
#
	#for point in $PointsOfInterest.get_children():
		#points_of_interest.push_back(point)
	#$Spawner.furniture_set_to_be_sold = points_of_interest
