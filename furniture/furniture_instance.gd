class_name FurnitureInstance
extends Node3D
@export var extra_size : PackedVector3Array
@export var visual_mesh : MeshInstance3D
@export var static_body : StaticBody3D
var furniture_data : FurnitureData
var first_press := true
var current_price : int = -1

var perfect_price : int:
	get:
		if furniture_data != null:
			return furniture_data.perfect_price
		else:
			return -1

@onready var for_sale_sign = preload("res://furniture/for_sale_sign.tscn").instantiate()

func _ready() -> void:
	add_child(for_sale_sign)
	static_body.mouse_entered.connect(_on_mouse_entered)
	static_body.mouse_exited.connect(_on_mouse_exit)
	static_body.input_event.connect(_on_static_body_3d_input_event)
	PlayerInventory.change_renown_amount(furniture_data.furniture_renown)
	
func _on_mouse_entered() -> void:
	EventBus.mouse_over_furniture.emit(self)
	
func _on_mouse_exit() -> void:
	EventBus.mouse_exits_furniture.emit(self)

func get_mesh_offset() -> Vector3:
	return visual_mesh.position

func get_mesh() -> Mesh:
	return visual_mesh.mesh

func remove_this_instance() -> void:
	PlayerInventory.add_object_to_inventory(furniture_data)
	queue_free()
func price_set(price : int) -> void:
	current_price = price
	if current_price > 0:
		for_sale_sign.visible = true
	else:
		for_sale_sign.visible = false
	EventBus.set_price.emit(self)
	
func sold() -> void:
	PlayerInventory.earn_money(current_price)
	
	EventBus.object_sold.emit(self)
	PlayerInventory.change_renown_amount(-furniture_data.furniture_renown)
	queue_free()


func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if first_press:
		first_press = false
		return
	if event.is_action_pressed("press"):
		EventBus.clicked_on_furniture.emit(self)
