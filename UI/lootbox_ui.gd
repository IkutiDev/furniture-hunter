extends Control


@export var lootbox_menu : Control

@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene

@export var exit_button : BaseButton

@export var video_player : VideoStreamPlayer

var cutscene_playing : bool = false

func _ready() -> void:
	EventBus.lootbox_opened.connect(_open_lootbox)
	EventBus.skip_lootbox_cutscene.connect(skip_cutscene)
	lootbox_menu.visible = false
	video_player.hide()
	video_player.finished.connect(on_cutscene_finished)
	exit_button.pressed.connect(close_menu)
	
func _toggle_auctions_menu() -> void:
	if lootbox_menu.visible:
		close_menu()
	else:
		open_menu()

func open_menu() -> void:
	lootbox_menu.show()
	EventBus.menu_open.emit(self)

func close_menu() -> void:
	lootbox_menu.hide()
	EventBus.menu_close.emit(self)


func skip_cutscene() -> void:
	video_player.stop()
	cutscene_playing = false

func on_cutscene_finished() -> void:
	cutscene_playing = false

func _open_lootbox(data : LootboxData):
	
	for c in %ButtonsShowingObjectsGoHere.get_children(): # clean up before next opening
		c.queue_free()
	open_menu()
	video_player.stream = data.lootbox_video
	video_player.show()
	cutscene_playing  = true
	video_player.play()
	#$Panel/SubViewportContainer/SubViewport/LootboxWorld.play()
	EventBus.play_lootbox_cutscene.emit()
	while cutscene_playing:
		await get_tree().process_frame
	EventBus.lootbox_cutscene_ended.emit()
	video_player.hide()
	var spawned_objects = data.spawn_objects() as Array # actual spawn the objects

	for object in spawned_objects:
		var button_scene : Control
		if object is ItemData:
			button_scene = item_button_scene.instantiate() as ItemButton
			button_scene.set_data(object)
		if object is FurnitureData:
			button_scene = furniture_button_scene.instantiate() as FurnitureButton
			button_scene.set_data(object)
		%ButtonsShowingObjectsGoHere.add_child(button_scene)
	pass
