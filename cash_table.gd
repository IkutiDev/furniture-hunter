extends MeshInstance3D

@export var player : AudioStreamPlayer3D


func _ready() -> void:
	
	EventBus.object_sold.connect(Callable(player,"play"))
