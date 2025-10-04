class_name Player
extends CharacterBody3D



@export_category("Movement")
@export var speed := 5.0
@export var dash_power := 7.0

var current_velocity = Vector3.ZERO

var dash_ready = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and dash_ready:
		dash_ready = false
		$DashAnimator.play("dash")
		current_velocity = speed * dash_power * current_velocity.normalized()


func movement(movement_vector : Vector2) -> void:
	
	current_velocity.x = movement_vector.x * speed
	current_velocity.z = movement_vector.y * speed

	
	if current_velocity:
		if Vector3.UP.cross(transform.origin + current_velocity - position).length() > 0:
			look_at(transform.origin + current_velocity, Vector3.UP)
		rotation.x = 0
		rotation.z = 0



func _physics_process(_delta):
	# gravity currently not in scope
	#if not is_on_floor():
		#current_velocity.y -= gravity * delta
		
	if !$DashAnimator.current_animation == "dash":
		movement(Input.get_vector("ui_left","ui_right","ui_up","ui_down"))

	velocity = current_velocity
	

	
	move_and_slide()


func _on_dash_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cool_down":
		dash_ready = true
	pass # Replace with function body.
