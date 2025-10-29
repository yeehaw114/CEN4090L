extends Node2D

@onready var exit_zone = $ExitZone

func _ready():
	exit_zone.body_entered.connect(_on_exit_entered)

func _on_exit_entered(body):
	if body.name == "Player":
		call_deferred("go_to_campfire")

func go_to_campfire():
	GameState.room_cleared()
	print('ROOMS CLEARED: '+str(GameState.rooms_cleared))
	GameState.change_scene(GameState.SCENES["campfire"])
