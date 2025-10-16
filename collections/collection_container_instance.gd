class_name CollectionContainerInstance
extends Node3D
@export var collection_slots : Array[CollectionInstance]
@export var static_body : StaticBody3D


func _ready():
	#static_body.mouse_entered.connect(_on_mouse_entered)
	#static_body.mouse_exited.connect(_on_mouse_exit)
	static_body.input_event.connect(_on_static_body_3d_input_event)


#func _on_mouse_entered() -> void:
	#EventBus.mouse_over_furniture.emit(self)
	#
#func _on_mouse_exit() -> void:
	#EventBus.mouse_exits_furniture.emit(self)


func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("press"):
		EventBus.clicked_on_collection.emit(self)
