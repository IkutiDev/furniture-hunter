extends MeshInstance3D

@export var player : AudioStreamPlayer3D

signal cash_pressed

func _ready() -> void:
	
	EventBus.object_sold.connect(Callable(player,"play"))


func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("press"):
		cash_pressed.emit()
		#EventBus.clicked_on_collection.emit(self)
	pass # Replace with function body.
