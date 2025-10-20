extends Area2D

@export var next_scene_path: String = "res://Scenes/Bunker.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body):
	get_tree().call_deferred("change_scene_to_file", next_scene_path)
