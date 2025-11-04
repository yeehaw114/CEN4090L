extends Area2D

@export var next_scene_id: String = "bunker"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body):
	GameState.start_run()
	GlobalAudioStreamPlayer.play_dungeon_music()
	GameState.change_scene(GameState.SCENES[next_scene_id])
