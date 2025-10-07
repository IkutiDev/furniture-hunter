extends State

# for making choices
# will need to send a lot of calls to the top
# all external events should transition the NPC to this state

@export var customer_body : Node3D

signal i_chose_to_browse

signal i_chose_to_leave

signal i_chose_to_walk

signal i_chose_to_buy

## pairs of options + weights
var possible_choices = {
	"i_chose_to_walk" : 6,
	"i_chose_to_browse" : 7,
	"i_chose_to_buy" : 5,
	"i_chose_to_leave" : 1,
	}

func enter(msg = []) -> void:
	var choice_list = possible_choices.duplicate()
	if !msg.is_empty():
		assert(typeof(msg[0]) == TYPE_STRING)
		make_a_choice(msg[0])
	else:
		make_a_choice()
	pass


func exit() -> void:
	
	pass




func make_a_choice(message = "nothing"):
	var selected_choice : String
	match message:
		"henlo world": # go stright to walk
			selected_choice = "i_chose_to_walk"
			pass
		"walking completed":
			selected_choice = "i_chose_to_browse"
			pass
		"idle completed":
			if customer_body.energy < 10 or customer_body.money < 20:
				selected_choice = "i_chose_to_leave"
				
			elif randf() > 0.7:
				selected_choice = "i_chose_to_browse"
			elif randf() > 0.65:
				selected_choice = "i_chose_to_buy"
			else:
				selected_choice = "i_chose_to_walk"
				
			pass
		


	
	print("selected_choice: ",selected_choice)
	emit_signal(selected_choice)
	match selected_choice:
		"i_chose_to_walk":
			customer_body.energy -= 10
			state_machine.transition_to("Walk")
		"i_chose_to_browse":
			customer_body.energy -= 5
			state_machine.transition_to("Idle",[3.0])
		"i_chose_to_leave":
			state_machine.transition_to("Walk")
		"i_chose_to_buy":
			state_machine.transition_to("Idle",[1.5])
	pass
