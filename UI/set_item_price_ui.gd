class_name SetItemPriceUI
extends ColorRect

@export var furniture_title_label : Label
#@export var furniture_description_label : Label
@export var close_ui_button : BaseButton


@export var item_slots : Array[Control]
@export var remove_furniture_button : BaseButton
@export var remove_furniture_button2 : BaseButton

var furniture_instance : FurnitureContainerInstance

func _ready() -> void:
	#EventBus.available_items_changed.connect(update_items_inventory)
	EventBus.clicked_on_furniture.connect(open_ui)
	EventBus.clicked_on_item.connect(set_item_inside_container)
	close_ui_button.pressed.connect(close_menu)
	remove_furniture_button.pressed.connect(remove_furniture)
	remove_furniture_button2.pressed.connect(remove_furniture)
	EventBus.selected_furniture_to_place.connect(funny_close_menu)
	close_menu()


func open_ui(instance: FurnitureContainerInstance) -> void:
	if instance == null:
		return
	if visible:
		return
	furniture_instance = instance
	furniture_title_label.text = furniture_instance.furniture_data.object_name
#	furniture_description_label.text = furniture_instance.furniture_data.description
	update_item_slots()
	# YOU CANT STOP ME BATMAN! I ALREADY CREATED A GLOBAL GROUP WHEN YOU WERENT LOOKING!!
	# AND NOW I AM REAKLESLY ACCESING STUFF ON THEM! HAhahaHAhahAHahAHAHahah!
	var main_UI = get_tree().get_nodes_in_group("MainUI")[0]
	if !main_UI.inventory_menu.visible:
		main_UI.on_inventory_button_pressed()
		main_UI.inventory_menu.show_items()
	EventBus.menu_open.emit(self)
	show()
	
func close_menu() -> void:
	furniture_instance = null
	hide()
	EventBus.menu_close.emit(self)
	
func funny_close_menu(data) -> void:
	close_menu()

func update_item_slots() -> void:
	var next = 0
	for s in furniture_instance.item_slots:
		item_slots[next].set_item_slot(s)
		next += 1
	pass
	#for s in furniture_instance.item_slots:
		#var item_slot_instance := item_slot_ui_scene.instantiate() as ItemSlotUI
		#item_slot_instance.set_item_slot(s)
		#item_slots_list.add_child(item_slot_instance)

#func update_items_inventory() -> void:
	#var children = item_list.get_children()
	#for c in children:
		#c.queue_free()
	#for i in PlayerInventory.items:
		#var item_button_instance := item_button_scene.instantiate() as ItemButton
		#item_button_instance.set_data(i)
		#item_list.add_child(item_button_instance)

func set_item_inside_container(data : ItemData) -> void:
	if furniture_instance == null:
		return
	if data == null:
		return
	for i in furniture_instance.item_slots.size():
		if furniture_instance.item_slots[i].item_data == null:
			
			furniture_instance.item_slots[i].set_data(data)
			(item_slots[i] as NewItemSlotUI).set_item_slot(furniture_instance.item_slots[i])
			PlayerInventory.remove_object_from_inventory(data)
			return
			
func remove_furniture() -> void:
	for i in furniture_instance.item_slots:
		if i == null:
			continue
		PlayerInventory.add_object_to_inventory(i.item_data)
	EventBus.furniture_removed.emit(furniture_instance)
	close_menu()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		close_menu()
	pass # Replace with function body.
