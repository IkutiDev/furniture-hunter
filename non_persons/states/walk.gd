extends State

# active when NPC is currently going somewhere
# takes the location of where to go as input message
# or not? possibly only a dummy state...


func enter(msg = []) -> void:

	pass

func _process(delta: float) -> void:
	
	if $"../../NavigationAgent3D".is_navigation_finished(): # this is bad an needs to be fixed... later
		state_machine.transition_to("Think",["walking completed"])
	pass

func exit() -> void:
	
	pass
