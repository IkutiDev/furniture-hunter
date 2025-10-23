class_name ToolTipPanel
extends Control

@export var offset : Vector2
@export var title_label : Label
@export var cost_label : Label
@export var description_label : Label
#@export var collection_type_label : RichTextLabel
#@export var object_preview : SubViewportContainer


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
		cost_label.text = str(data.perfect_price)#"Rec: " + str(data.perfect_price) +"$"
		description_label.text = data.description
		#collection_type_label.text  = CollectionSet.get_set_name(data.collection_set_type)
		#if data is FurnitureData:
			#object_preview.shown_mesh = data.get_visual_mesh()
		#else:
			#object_preview.shown_mesh = null
