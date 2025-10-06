extends State

# for making choices
# will need to send a lot of calls to the top
# all external events should transition the NPC to this state

signal i_chose_to_browse

signal i_chose_to_leave

signal i_chose_to_walk


## pairs of options + weights
var possible_choices = {
	"i_chose_to_walk" : 6,
	"i_chose_to_browse" : 7,
	"i_chose_to_leave" : 1
		}

func enter(msg = []) -> void:
	var choice_list = possible_choices.duplicate()
	if !msg.is_empty():
		if msg[0] == "henlo world":
			choice_list["i_chose_to_leave"] -= 1
			choice_list["i_chose_to_browse"] -= 7
		if msg[0] == "idle completed":
			choice_list["i_chose_to_browse"] -= 3
		if msg[0] == "walking completed":
			choice_list["i_chose_to_walk"] -= 5
	make_a_choice(choice_list)
	pass


func exit() -> void:
	
	pass


func make_a_choice(choice_list = {}):
	var total_choice_weight = 0
	for key in choice_list.keys():
		total_choice_weight += choice_list[key]

	print("my choices are: ",choice_list)
	var random_choice = randi()%total_choice_weight
	var selected_choice : String
	print("I rolled a: ",random_choice)
	for key in choice_list.keys():
		random_choice -= choice_list[key]
		if random_choice < 0:
			selected_choice = key
			break
	
	print("selected_choice: ",selected_choice)
	emit_signal(selected_choice)
	match selected_choice:
		"i_chose_to_walk":
			state_machine.transition_to("Walk")
		"i_chose_to_browse":
			state_machine.transition_to("Idle",[4.0])
		"i_chose_to_leave":
			state_machine.transition_to("Walk")
	pass
