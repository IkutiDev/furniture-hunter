extends AudioListener3D


@export var signal_to_stream_map : Dictionary


# signal furniture_removed(instance)
# signal collection_crafted(collection_data)
# signal menu_open(control)
# signal menu_close(control)
# signal start_day()
# signal end_day()
# signal start_night()



func _ready() -> void:
	#EventBus.available_lootboxes_changed.connect()
	for thing in signal_to_stream_map:
		var new_effect = AudioStreamPlayer.new()
		new_effect.bus = "Effects"
		new_effect.stream = signal_to_stream_map[thing]
		EventBus.connect(thing,Callable(new_effect,"play"))

		add_child(new_effect)
	

	pass


#func play
#
#
#
	#EventBus.object_sold.connect(Callable(player,"play"))


func _on_music_player_finished() -> void:
	$MusicPlayer.play()
	pass # Replace with function body.
