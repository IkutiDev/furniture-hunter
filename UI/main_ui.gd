class_name MainUI
extends Control
@export var remove_furnitue_button : BaseButton
@export var change_shop_state_button : Button
@export var button_color_during_day : Theme
@export var button_text_during_day : String
@export var button_color_during_night : Theme
@export var button_text_during_night : String

@export var hour_label : Label

func _ready() -> void:
	remove_furnitue_button.pressed.connect(destroy_furniture_button_pressed)
	change_shop_state_button.pressed.connect(change_current_state)
	EventBus.game_state_changed.connect(on_game_state_changed)
	EventBus.update_game_time.connect(update_current_time)


func change_current_state() -> void:
	if GameManager.game_state == GameManager.GameState.NIGHT:
		GameManager.set_game_state(GameManager.GameState.DAY)
	elif GameManager.game_state == GameManager.GameState.DAY:
		GameManager.set_game_state(GameManager.GameState.ENDING_DAY)

func update_current_time(hour : int) -> void:
	hour_label.text = str(hour) + ":00"

func on_game_state_changed() -> void:
	match GameManager.game_state:
		GameManager.GameState.NIGHT:
			change_shop_state_button.disabled = false
			change_shop_state_button.text = button_text_during_night
			change_shop_state_button.theme =  button_color_during_night
		GameManager.GameState.DAY:
			change_shop_state_button.disabled = true
			change_shop_state_button.text = button_text_during_day
			change_shop_state_button.theme = button_color_during_day
			get_tree().create_timer(GameManager.HOW_MANY_SECONDS_IS_HOUR).timeout.connect(enable_button_during_day)
		GameManager.GameState.ENDING_DAY:
			change_shop_state_button.disabled = true


func enable_button_during_day() -> void:
	change_shop_state_button.disabled = false

func destroy_furniture_button_pressed() -> void:
	EventBus.deselect_current_furniture.emit()
	EventBus.set_remove_furniture_mode.emit(true)
