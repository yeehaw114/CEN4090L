extends Area2D

@export var next_scene_path: String = "res://Scenes/Lobby.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(_body):
	get_tree().change_scene_to_file(next_scene_path)
