extends Area2D

@export var next_scene_id: String = "lobby"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body):
	GameState.change_scene(GameState.SCENES[next_scene_id])
