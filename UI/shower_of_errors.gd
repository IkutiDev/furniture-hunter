extends Label

func _ready() -> void:
	EventBus.connect("throw_error",show_error_message)
	pass
	
	
func show_error_message(message : String):
	if $Anime.is_playing():
		$Anime.stop()
	text = message
	$Anime.play("fade_out")
	pass
