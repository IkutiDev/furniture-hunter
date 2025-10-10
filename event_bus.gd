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
signal clicked_on_item(item_data)

signal set_price(object)
signal object_sold(object)

signal money_value_changed()

signal on_icon_hovered(control, data)

signal update_game_time(hour)

signal start_day()
signal end_day()
signal start_night()
signal game_state_changed()
@warning_ignore_restore("UNUSED_SIGNAL")
