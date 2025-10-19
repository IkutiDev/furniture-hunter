extends Control


@export var lootbox_menu : Control
@export var open_menu_button : BaseButton

@export var furniture_button_scene : PackedScene
@export var item_button_scene : PackedScene

func _ready() -> void:
	open_menu_button.pressed.connect(_toggle_auctions_menu)
	EventBus.lootbox_opened.connect(_open_lootbox)
	EventBus.skip_lootbox_cutscene.connect(skip_cutscene)
	lootbox_menu.visible = false
	
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
	$Panel/SubViewportContainer/SubViewport/LootboxWorld.early_end()



func _open_lootbox(data : LootboxData):
	
	for c in %ButtonsShowingObjectsGoHere.get_children(): # clean up before next opening
		c.queue_free()
	open_menu()
	$Panel/SubViewportContainer/SubViewport/LootboxWorld.play()
	EventBus.play_lootbox_cutscene.emit()
	await $Panel/SubViewportContainer/SubViewport/LootboxWorld.animation_complete # wait for the animation to finish
	EventBus.lootbox_cutscene_ended.emit()
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
