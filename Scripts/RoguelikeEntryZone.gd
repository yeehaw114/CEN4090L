extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":   # Adjust if your player node has a different name
		get_tree().change_scene_to_file("res://Scenes/RoomSelection.tscn")
