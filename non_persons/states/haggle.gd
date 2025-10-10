extends State


var haggle_node : Node3D





func enter(msg = []) -> void:
	haggle_node = msg[0] # very dangerous assumption that this is what I hope it is
	assert(haggle_node.has_signal("haggle_resolved"))
	haggle_node.connect("haggle_resolved",Callable(self,"post_haggle_clarity"))
	pass

func _process(delta: float) -> void:
	assert(haggle_node.haggle_time_left > 0.0)
	pass

func exit() -> void:
	
	pass



func post_haggle_clarity(result : String): # :D hehehe
	
	pass
