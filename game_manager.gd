extends Node

enum GameState {NIGHT, DAY, ENDING_DAY}

var game_state : GameState

var current_time := 0.0
const END_DAY_HOUR = 16
const BASE_HOUR = 8
const HOW_MANY_SECONDS_IS_HOUR = 10.0

func set_game_state(new_game_state : GameState) -> void:
	game_state = new_game_state
	EventBus.game_state_changed.emit()
	match game_state:
		GameState.DAY:
			current_time = 0
			EventBus.start_day.emit()
			EventBus.update_game_time.emit(8)
		GameState.ENDING_DAY:
			EventBus.end_day.emit()
		GameState.NIGHT:
			EventBus.start_night.emit()
			EventBus.update_game_time.emit(20)

func _process(delta: float) -> void:
	if game_state == GameState.DAY:
		current_time += delta
		var current_hour : int = BASE_HOUR + (current_time / HOW_MANY_SECONDS_IS_HOUR)
		EventBus.update_game_time.emit(current_hour)
		if current_hour >= END_DAY_HOUR:
			set_game_state(GameState.ENDING_DAY)
		
