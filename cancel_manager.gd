class_name CancelManager
extends Node

@export var object_placer : ObjectPlacer

var control_menus_queue : Array[Control]
var lootbox_cutscene_active := false

func _ready() -> void:
	EventBus.menu_open.connect(add_menu_to_queue)
	EventBus.menu_close.connect(remove_menu_to_queue)
	EventBus.play_lootbox_cutscene.connect(lootbox_cutscene_opened)
	EventBus.lootbox_cutscene_ended.connect(lootbox_cutscene_closed)
	
func add_menu_to_queue(menu : Control) -> void:
	control_menus_queue.append(menu)

func remove_menu_to_queue(menu : Control) -> void:
	control_menus_queue.erase(menu)

func lootbox_cutscene_opened() -> void:
	lootbox_cutscene_active = true

func lootbox_cutscene_closed() -> void:
	lootbox_cutscene_active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if lootbox_cutscene_active:
			EventBus.skip_lootbox_cutscene.emit()
			return
		var menu = control_menus_queue.pop_back()
		if menu == null:
			if object_placer.selected_furniture != null:
				object_placer.deselect_furniture()
			return
		menu.close_menu()
