extends Node2D

func _ready():
	await get_tree().create_timer(2.0).timeout
	call_deferred("go_to_campfire")

func go_to_campfire():
	get_tree().change_scene_to_file("res://Scenes/Campfire.tscn")
