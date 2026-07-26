extends CenterContainer

@export var start_game_scene : PackedScene

@export var textures_to_load : Array[Resource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_progress = textures_to_load.size()
	var current_progress = 0
	for texture in textures_to_load:
		load_next_texture(texture)
		await get_tree().create_timer(0.27)
		current_progress += 1
		$Background/VBoxContainer/TextureProgressBar.value = current_progress / start_progress
		
	get_tree().change_scene_to_packed(start_game_scene)
	pass # Replace with function body.

func load_next_texture(texture):
	var mesh = $SubViewport/MeshInstance3D.mesh as PlaneMesh
	var material = mesh.material as BaseMaterial3D
	material.set_texture(BaseMaterial3D.TEXTURE_ALBEDO,texture)
	
