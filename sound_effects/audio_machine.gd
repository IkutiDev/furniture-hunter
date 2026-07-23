extends AudioListener3D


@export var signal_to_stream_map : Dictionary




func _ready() -> void:

	for thing in signal_to_stream_map:
		var new_effect = AudioStreamPlayer.new()
		new_effect.bus = "Effects"
		new_effect.stream = signal_to_stream_map[thing]
		EventBus.connect(thing,Callable(new_effect,"play").unbind(1))

		add_child(new_effect)
	

	pass


func signal_to_sound(input_signal : Signal) -> void:
	
	pass


func _on_music_player_finished() -> void:
	$MusicPlayer.play()
	pass # Replace with function body.
