class_name ToolTipPanel
extends Control

@export var offset : Vector2
@export var title_label : Label
@export var cost_label : Label
@export var description_label : Label
@export var bottom_line : Control
@export var content_layout : Control
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
		modulate = Color(1,1,1,0)
		global_position = control.global_position + offset
		title_label.text = data.object_name
		cost_label.text = str(data.perfect_price)#"Rec: " + str(data.perfect_price) +"$"
		var object_description = data.description as String
		description_label.text = object_description
		if object_description.is_empty():
			bottom_line.visible = false
			description_label.visible = false
		else:
			bottom_line.visible = true
			description_label.visible = true
		await get_tree().create_timer(0.05).timeout
		$ColorRect.size.y = content_layout.size.y
		
		modulate = Color(1,1,1,1)
		#collection_type_label.text  = CollectionSet.get_set_name(data.collection_set_type)
		#if data is FurnitureData:
			#object_preview.shown_mesh = data.get_visual_mesh()
		#else:
			#object_preview.shown_mesh = null
