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


func change_current_state() -> void:
	if GameManager.game_state == GameManager.GameState.NIGHT:
		GameManager.set_game_state(GameManager.GameState.DAY)
	elif GameManager.game_state == GameManager.GameState.DAY:
		GameManager.set_game_state(GameManager.GameState.ENDING_DAY)


func _on_open_shop_pressed() -> void:
	change_current_state()

	pass # Replace with function body.
