class_name CustomerData
extends Resource

@export var client_name : String
@export var starting_money : int
@export var client_scene : PackedScene
#@export var purchase_preferences : Dictionary # paires of adjectives + wieghts / weights are added to item value when calcualting wether a deal is good or bad
var entrance_location : Vector3
var exit_location : Vector3
@export var walk_speed : float
@export var love_tags : Array[Tags.Types]
@export var liked_tags : Array[Tags.Types]
@export var disliked_tags : Array[Tags.Types]
@export var hated_tags : Array[Tags.Types]
