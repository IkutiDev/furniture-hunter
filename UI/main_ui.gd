class_name MainUI
extends Control
@export var change_shop_state_button : Button
@export var button_color_during_day : Theme
@export var button_text_during_day : String
@export var button_color_during_night : Theme
@export var button_text_during_night : String

@export var money_label : Label
@export var renown_label : Label
@export var hour_label : Label

@export var inventory_menu : InventoryUI

@export var active_button_texture : Texture2D
@export var disactive_button_texture : Texture2D

@export var inventory_button : TextureButton

func _ready() -> void:
	change_shop_state_button.pressed.connect(change_current_state)
	EventBus.game_state_changed.connect(on_game_state_changed)
	EventBus.update_game_time.connect(update_current_time)
	EventBus.money_value_changed.connect(on_money_value_changed)
	EventBus.renown_value_changed.connect(on_renown_value_changed)
	inventory_button.pressed.connect(on_inventory_button_pressed)
	on_money_value_changed()
	on_renown_value_changed()
	EventBus.menu_close.connect(on_menu_close)


func change_current_state() -> void:
	if GameManager.game_state == GameManager.GameState.NIGHT:
		GameManager.set_game_state(GameManager.GameState.DAY)
	elif GameManager.game_state == GameManager.GameState.DAY:
		GameManager.set_game_state(GameManager.GameState.ENDING_DAY)

func update_current_time(hour : int) -> void:
	hour_label.text = str(hour) + ":00"

func on_money_value_changed() -> void:
	money_label.text = str(PlayerInventory.money)

func on_renown_value_changed() -> void:
	renown_label.text = str(PlayerInventory.renown)

func on_inventory_button_pressed() -> void:
	inventory_menu.open_menu()
	inventory_button.texture_normal = active_button_texture
	
func on_menu_close(menu) -> void:
	if menu is InventoryUI:
		inventory_button.texture_normal = disactive_button_texture

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
