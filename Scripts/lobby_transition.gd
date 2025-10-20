extends Area2D

@export var next_scene_id : String = "bunker"  

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameState.change_scene(GameState.SCENES[next_scene_id])
