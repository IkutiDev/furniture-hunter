extends Control


@export var lootbox_menu : Control
@export var open_menu_button : BaseButton



func _ready() -> void:
	open_menu_button.pressed.connect(_toggle_auctions_menu)
	EventBus.lootbox_opened.connect(_open_lootbox)
	
func _toggle_auctions_menu() -> void:
	lootbox_menu.visible = !lootbox_menu.visible




func _open_lootbox(data : LootboxData):
	lootbox_menu.visible = true
	$Panel/SubViewportContainer/SubViewport/LootboxWorld.play()
	await $Panel/SubViewportContainer/SubViewport/LootboxWorld.animation_complete
	print(data.spawn_objects())
	pass
