extends Node2D

@onready var exit_zone = $ExitZone  # This must exist in your scene as an Area2D

func _ready():
	exit_zone.body_entered.connect(_on_exit_entered)

func _on_exit_entered(body):
	if body.name == "Player":
		call_deferred("go_to_room_selection")

func go_to_room_selection():
	get_tree().change_scene_to_file("res://Scenes/RoomSelection.tscn")
