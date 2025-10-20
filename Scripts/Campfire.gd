extends Node2D

@onready var exit_zone = $ExitZone

func _ready():
	exit_zone.body_entered.connect(_on_exit_entered)

func _on_exit_entered(body):
	if body.name == "Player":
		GameState.change_scene(GameState.SCENES["map"])  # or "room_selection" as desired
