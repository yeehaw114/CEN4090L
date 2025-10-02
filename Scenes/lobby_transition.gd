extends Area2D

@export var next_scene_path : String = "res://Bunker.tscn"


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):  # or use body.name if you haven't set groups
		get_tree().change_scene(next_scene_path)
