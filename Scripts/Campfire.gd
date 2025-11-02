extends Node2D

@onready var exit_zone = $ExitZone
@onready var exit_zone_2: Area2D = $ExitZone2
@onready var warning_screen: Control = $CanvasLayer/WarningScreen
@onready var player: CharacterBody2D = $Player

func _ready():
	exit_zone.body_entered.connect(_on_exit_entered)
	exit_zone_2.body_entered.connect(attempt_end_run)
	GlobalAudioStreamPlayer.play_lobby_music()

func _on_exit_entered(body):
	if body.name == "Player":
		GameState.change_scene(GameState.SCENES["room_selection"])  # or "room_selection" as desired
		GlobalAudioStreamPlayer.play_dungeon_music()

func attempt_end_run(body):
	if body.name == "Player":
		warning_screen.show()
		player.toggle_able_to_move(false)


func _on_continue_button_pressed() -> void:
	player.toggle_able_to_move(true)
	warning_screen.hide()


func _on_flee_button_pressed() -> void:
	GameState.change_scene(GameState.SCENES["lobby"])
