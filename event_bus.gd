extends Node
@warning_ignore_start("UNUSED_SIGNAL")
signal deselect_current_furniture()
signal selected_furniture_to_place(furniture_data)
signal available_furniture_changed()
signal available_items_changed()
signal available_lootboxes_changed()
signal mouse_over_furniture(instance)
signal mouse_exits_furniture(instance)
signal set_remove_furniture_mode(active)
signal clicked_on_furniture(furniture)

signal set_price_on_furniture(furniture)
signal furniture_sold()

signal money_value_changed()

signal start_day()
signal end_day()
signal start_night()
signal game_state_changed()
@warning_ignore_restore("UNUSED_SIGNAL")
