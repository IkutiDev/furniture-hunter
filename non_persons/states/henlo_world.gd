extends State

# Inital state, only here to switch to walking

@export var intial_wait_time = 2.0


func _process(delta: float) -> void:
	if $"../../NavigationAgent3D".is_navigation_finished():
		state_machine.transition_to("Think",["henlo world"])
