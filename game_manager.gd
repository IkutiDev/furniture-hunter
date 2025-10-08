extends Node

enum GameState {NIGHT, DAY, ENDING_DAY}

var game_state : GameState

func set_game_state(new_game_state : GameState) -> void:
	game_state = new_game_state
	EventBus.game_state_changed.emit()
	match game_state:
		GameState.DAY:
			EventBus.start_day.emit()
		GameState.ENDING_DAY:
			EventBus.end_day.emit()
		GameState.NIGHT:
			EventBus.start_night.emit()
