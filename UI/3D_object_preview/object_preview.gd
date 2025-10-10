extends SubViewportContainer


@export var shown_mesh : Mesh:
	set(value):
		$SubViewport/World.change_shown_object(value)

	
