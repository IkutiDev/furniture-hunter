class_name CashRegisterUI
extends Control

@export var close_menu_button : BaseButton

func _ready() -> void:
	close_menu_button.pressed.connect(close_menu)

func open_menu() -> void:
	show()
	EventBus.menu_open.emit(self)



func close_menu() -> void:
	hide()
	EventBus.menu_close.emit(self)




func _on_open_shop_pressed() -> void:

	
	if GameManager.game_state == GameManager.GameState.NIGHT:
		if get_tree().get_nodes_in_group("Spawner").pick_random().objects_set_to_be_sold.size() == 0: # a dirty check if there is no stuff to buy
			EventBus.throw_error.emit("YOU CAN'T OPEN THE SHOP - THERE ARE NO BUYABLE ITEMS")
		else:
			GameManager.set_game_state(GameManager.GameState.DAY)
	elif GameManager.game_state == GameManager.GameState.DAY:
		GameManager.set_game_state(GameManager.GameState.ENDING_DAY)
	else:
		EventBus.throw_error.emit("YOU CAN'T DO THAT RIGHT NOW")

	pass # Replace with function body.


func _on_wallpaper_pressed() -> void:
	EventBus.emit_signal("wallpaper_changed")
	pass # Replace with function body.
