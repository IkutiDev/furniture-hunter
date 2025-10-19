class_name SetFurniturePriceUI
extends Control

@export var furniture_title_label : Label
@export var furniture_description_label : Label
@export var recommended_price_label : Label
@export var current_price_label : Label
@export var price_box : SpinBox
@export var set_price_button : BaseButton
@export var close_ui_button : BaseButton
@export var remove_furniture_button : BaseButton

var furniture_instance : FurnitureInstance

func _ready() -> void:
	EventBus.clicked_on_furniture.connect(open_ui)
	close_ui_button.pressed.connect(close_menu)
	set_price_button.pressed.connect(set_price)
	remove_furniture_button.pressed.connect(remove_furniture)
	close_menu()

func open_ui(instance: FurnitureInstance) -> void:
	if instance == null:
		return
	if instance is FurnitureContainerInstance:
		return
	if visible:
		return
	furniture_instance = instance
	furniture_title_label.text = furniture_instance.furniture_data.object_name
	furniture_description_label.text = furniture_instance.furniture_data.description
	recommended_price_label.text = str(furniture_instance.furniture_data.base_value) +"$"
	current_price_label.text = str(furniture_instance.current_price if furniture_instance.current_price >= 0 else 0) +"$"
	price_box.value = furniture_instance.current_price if furniture_instance.current_price >= 0 else 0
	
	EventBus.menu_open.emit(self)
	
	show()
	
func close_menu() -> void:
	hide()
	EventBus.menu_close.emit(self)

func remove_furniture() -> void:
	close_menu()
	EventBus.furniture_removed.emit(furniture_instance)

func set_price() -> void:
	@warning_ignore("narrowing_conversion")
	furniture_instance.price_set(price_box.value)
	current_price_label.text = str(furniture_instance.current_price if furniture_instance.current_price >= 0 else 0) +"$"
