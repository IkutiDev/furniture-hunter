extends State

# for making choices
# will need to send a lot of calls to the top
# all external events should transition the NPC to this state

@export var customer_body : Node3D

signal i_chose_to_browse

signal i_chose_to_leave

signal i_chose_to_walk

signal i_chose_to_buy

var brain_power = 1.0

## pairs of options + weights
var possible_choices = {
	"i_chose_to_walk" : 6,
	"i_chose_to_browse" : 7,
	"i_chose_to_buy" : 5,
	"i_chose_to_leave" : 1,
	}

func enter(msg = []) -> void:
	print(msg)
	brain_power = 1.0
	var choice_list = possible_choices.duplicate()
	if !msg.is_empty():
		assert(typeof(msg[0]) == TYPE_STRING)
		make_a_choice(msg[0])
	else:
		make_a_choice()
	pass

func _process(delta: float) -> void:
	brain_power -= delta
	assert(brain_power > 0)
	pass

func exit() -> void:
	
	pass




func make_a_choice(message = "nothing"):
	var selected_choice : String
	
	if customer_body.energy < 10 or customer_body.money < 20:
		selected_choice = "i_chose_to_leave"
		message = "nothing"
	match message:
		"buy failed":
			
			selected_choice = "i_chose_to_walk"
			pass
		"henlo world": # go stright to walk
			selected_choice = "i_chose_to_walk"
			pass
		"walking completed":
			selected_choice = "i_chose_to_browse"
			pass
		"nothing to buy":
			selected_choice = "i_chose_to_walk"
			pass
		"idle completed":
				
			if randf() > 0.7:
				selected_choice = "i_chose_to_browse"
			elif randf() > 0.25:
				selected_choice = "i_chose_to_buy"
			else:
				selected_choice = "i_chose_to_walk"
				
			pass
		


	
	print("selected_choice: ",selected_choice)
	emit_signal(selected_choice)

	pass
