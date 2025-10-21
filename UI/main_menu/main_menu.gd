extends CanvasLayer


func _ready():
	get_tree().paused = true
	$Credits.visible = false
	$Tutorial.visible = false
	pass

func _toggle_menu():
	
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		_on_resume_button_pressed()


func _on_credits_button_pressed() -> void:
	$Credits.visible = true
	pass # Replace with function body.


func _on_tutorial_button_pressed() -> void:
	$Tutorial.visible = true
	pass # Replace with function body.


func _on_resume_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _exit_tree() -> void:
	get_tree().paused = false


func _on_hide_tutorial_pressed() -> void:
	$Tutorial.visible = false
	pass # Replace with function body.


func _on_hide_credits_pressed() -> void:
	$Credits.visible = false
	pass # Replace with function body.


func _on_next_tutorial_pressed() -> void:
	if $Tutorial/HowToCraft.visible:
		$Tutorial/HowToCraft.visible = false
		$Tutorial/HowToSell.visible = false
	elif $Tutorial/HowToSell.visible:
		$Tutorial/HowToCraft.visible = true
	else:
		$Tutorial/HowToSell.visible = true



	
	
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	$Settings.visible = true
	pass # Replace with function body.


func _on_hide_settings_pressed() -> void:
	$Settings.visible = false
	pass # Replace with function body.
