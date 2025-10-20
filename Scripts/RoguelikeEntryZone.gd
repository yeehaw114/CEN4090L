extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/RoomSelection.tscn")
