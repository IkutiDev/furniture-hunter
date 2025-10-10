class_name ToolTipPanel
extends Panel

@export var offset : Vector2
@export var title_label : Label
@export var cost_label : Label
@export var collection_type_label : RichTextLabel

func _ready() -> void:
	EventBus.on_icon_hovered.connect(_on_hover)
	hide()
	
func _on_hover(control : Control, data) -> void:
	if control == null:
		hide()
	else:
		show()
		global_position = control.global_position + offset
		title_label.text = data.object_name
		cost_label.text = "Rec: " + str(data.perfect_price) +"$"
		collection_type_label.text  = CollectionSet.get_set_name(data.collection_set_type)
