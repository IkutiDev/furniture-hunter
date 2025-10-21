class_name MainUI
extends Control
@export var change_shop_state_button : Button
@export var button_text_during_day : String
@export var button_text_during_night : String

@export var money_label : Label
@export var renown_label : Label
@export var hour_label : Label

@export var inventory_menu : InventoryUI
@export var crafting_menu : CraftingUI
@export var auctions_menu : AuctionUI
@export var main_menu_scene : PackedScene
@export var active_button_texture : Texture2D
@export var disactive_button_texture : Texture2D

@export var inventory_button : TextureButton
@export var collections_button : TextureButton
@export var keys_button : TextureButton
@export var pause_menu_button : TextureButton



func _ready() -> void:
	change_shop_state_button.pressed.connect(change_current_state)
	EventBus.game_state_changed.connect(on_game_state_changed)
	EventBus.update_game_time.connect(update_current_time)
	EventBus.money_value_changed.connect(on_money_value_changed)
	EventBus.renown_value_changed.connect(on_renown_value_changed)
	inventory_button.pressed.connect(on_inventory_button_pressed)
	collections_button.pressed.connect(on_collections_button_pressed)
	keys_button.pressed.connect(on_keys_button_pressed)
	pause_menu_button.pressed.connect(on_pause_button_pressed)
	on_money_value_changed()
	on_renown_value_changed()
	EventBus.menu_close.connect(on_menu_close)
	on_game_state_changed()


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
	if crafting_menu.visible:
		crafting_menu.close_menu()
	if auctions_menu.visible:
		auctions_menu.close_menu()
		
	inventory_button.texture_normal = disactive_button_texture
	keys_button.texture_normal = disactive_button_texture
	collections_button.texture_normal = disactive_button_texture
	pause_menu_button.texture_normal = disactive_button_texture
	
	if not inventory_menu.visible:
		inventory_menu.open_menu()
		inventory_button.texture_normal = active_button_texture
	else:
		inventory_button.texture_normal = disactive_button_texture
		inventory_menu.close_menu()

func on_collections_button_pressed() -> void:
	if inventory_menu.visible:
		inventory_menu.close_menu()
	if auctions_menu.visible:
		auctions_menu.close_menu()
		
	inventory_button.texture_normal = disactive_button_texture
	keys_button.texture_normal = disactive_button_texture
	collections_button.texture_normal = disactive_button_texture
	pause_menu_button.texture_normal = disactive_button_texture
	
	if not crafting_menu.visible:
		crafting_menu.open_menu()
		collections_button.texture_normal = active_button_texture
	else:
		collections_button.texture_normal = disactive_button_texture
		crafting_menu.close_menu()

func on_keys_button_pressed() -> void:
	if inventory_menu.visible:
		inventory_menu.close_menu()
	if crafting_menu.visible:
		crafting_menu.close_menu()
		
	inventory_button.texture_normal = disactive_button_texture
	keys_button.texture_normal = disactive_button_texture
	collections_button.texture_normal = disactive_button_texture
	pause_menu_button.texture_normal = disactive_button_texture
	
	if not auctions_menu.visible:
		auctions_menu.open_menu()
		keys_button.texture_normal = active_button_texture
	else:
		keys_button.texture_normal = disactive_button_texture
		auctions_menu.close_menu()
		
func on_pause_button_pressed() -> void:
	if inventory_menu.visible:
		inventory_menu.close_menu()
	if crafting_menu.visible:
		crafting_menu.close_menu()
	if auctions_menu.visible:
		auctions_menu.close_menu()
		
	inventory_button.texture_normal = disactive_button_texture
	keys_button.texture_normal = disactive_button_texture
	collections_button.texture_normal = disactive_button_texture
	pause_menu_button.texture_normal = disactive_button_texture
	
	var new_main_menu = main_menu_scene.instantiate()
	get_tree().current_scene.add_child(new_main_menu)
func on_menu_close(menu) -> void:
	if menu is InventoryUI:
		inventory_button.texture_normal = disactive_button_texture
	elif menu is AuctionUI:
		keys_button.texture_normal = disactive_button_texture
	elif menu is CraftingUI:
		collections_button.texture_normal = disactive_button_texture
	elif menu is MainMenuUI:
		pause_menu_button.texture_normal = disactive_button_texture

func on_game_state_changed() -> void:
	match GameManager.game_state:
		GameManager.GameState.NIGHT:
			change_shop_state_button.disabled = false
			change_shop_state_button.text = button_text_during_night
			change_shop_state_button.add_theme_color_override("font_color", Color.SEA_GREEN)
			change_shop_state_button.add_theme_color_override("font_pressed_color", Color.SEA_GREEN)
			change_shop_state_button.add_theme_color_override("font_hover_color", Color.SEA_GREEN)
			change_shop_state_button.add_theme_color_override("font_disabled_color", Color.DARK_GREEN)
		GameManager.GameState.DAY:
			change_shop_state_button.disabled = true
			change_shop_state_button.text = button_text_during_day
			change_shop_state_button.add_theme_color_override("font_color", Color.DARK_RED)
			change_shop_state_button.add_theme_color_override("font_pressed_color", Color.DARK_RED)
			change_shop_state_button.add_theme_color_override("font_hover_color", Color.DARK_RED)
			change_shop_state_button.add_theme_color_override("font_disabled_color", Color.INDIAN_RED)
			get_tree().create_timer(GameManager.HOW_MANY_SECONDS_IS_HOUR).timeout.connect(enable_button_during_day)
		GameManager.GameState.ENDING_DAY:
			change_shop_state_button.disabled = true


func enable_button_during_day() -> void:
	change_shop_state_button.disabled = false
