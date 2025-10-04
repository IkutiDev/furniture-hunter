class_name Player
extends CharacterBody3D



@export_category("Movement")
@export var speed := 5.0

var current_velocity = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func movement(movement_vector : Vector2) -> void:
	
	current_velocity.x = movement_vector.x * speed
	current_velocity.z = movement_vector.y * speed

	
	if current_velocity:
		if Vector3.UP.cross(transform.origin + current_velocity - position).length() > 0:
			look_at(transform.origin + current_velocity, Vector3.UP)
		rotation.x = 0
		rotation.z = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		current_velocity.y -= gravity * delta
		



	movement(Input.get_vector("ui_left","ui_right","ui_up","ui_down"))

	velocity = current_velocity
	

	
	move_and_slide()
