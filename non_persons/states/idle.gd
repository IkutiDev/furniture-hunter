extends State

# for simulating looking at / browsing things
# idle_time is collected and sent as a signal to track the actual time the NPC has spent idling for calculating exit time
# goes to Think once time runs out

var wait_time = 0.5

var idle_time = 0.0

func enter(msg = []) -> void:
	if msg.is_empty():
		wait_time = 1.0 + randf() * 3
	else:
		assert(msg.size() == 1)
		
		assert(typeof(msg[0]) == TYPE_INT or typeof(msg[0]) == TYPE_FLOAT)
		wait_time = msg[0]
	pass

func _process(delta: float) -> void:
	wait_time -= delta
	idle_time += delta
	if wait_time <= 0:
		state_machine.transition_to("Think",["idle completed"])
	pass


func exit() -> void:
	# emit signal with idle_time
	wait_time = 0.5
	pass
