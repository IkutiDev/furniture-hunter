class_name SetCollectionUI
extends Control





@export var close_ui_button : BaseButton
@export var collection_list : Control
@export var collection_button_scene : PackedScene
@export var collection_slots_list : Control
@export var collection_slot_ui_scene : PackedScene

var collection_container_instance : CollectionContainerInstance

func _ready() -> void:
	EventBus.available_collections_changed.connect(update_collections_inventory)
	EventBus.clicked_on_collection.connect(open_ui)
	EventBus.clicked_on_collection.connect(set_collection_inside_container)
	close_ui_button.pressed.connect(close_ui)
	close_ui()


func open_ui(instance: CollectionContainerInstance) -> void:
	if instance == null:
		return
	if visible:
		return
	collection_container_instance = instance

	update_collection_slots()
	show()
	
func close_ui() -> void:
	collection_container_instance = null
	hide()


func update_collection_slots() -> void:
	var children = collection_slots_list.get_children()
	for c in children:
		c.queue_free()
	for s in collection_container_instance.collection_slots:
		var collection_slot_instance := collection_slot_ui_scene.instantiate() as CollectionSlotUI
		collection_slot_instance.set_collection_slot(s)
		collection_slots_list.add_child(collection_slot_instance)

func update_collections_inventory() -> void:
	var children = collection_list.get_children()
	for c in children:
		c.queue_free()
	for i in PlayerInventory.collections:
		var collection_button_instance := collection_button_scene.instantiate() as CollectionButton
		collection_button_instance.set_data(i)
		collection_list.add_child(collection_button_instance)

func set_collection_inside_container(data : CollectionData) -> void:
	if collection_container_instance == null:
		return
	if data == null:
		return
	for i in collection_container_instance.collection_slots.size():
		if collection_container_instance.collection_slots[i].collection_data == null:
			collection_container_instance.collection_slots[i].set_data(data)
			(collection_slots_list.get_child(i) as CollectionSlotUI).set_collection_slot(collection_container_instance.collection_slots[i])
			PlayerInventory.remove_object_from_inventory(data)
			return
