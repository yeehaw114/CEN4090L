extends Node2D
class_name Room

@export var room_name := 'Foggy Clearing'
@export var danger := 'Caution Advised'

@onready var exit_zone = $ExitZone

func _ready():
	exit_zone.body_entered.connect(_on_exit_entered)

func _on_exit_entered(body):
	if body.name == "Player":
		if GameState.rooms_cleared == 3 or GameState.rooms_cleared == 6:
			call_deferred("go_to_campfire")
		else:
			call_deferred("go_to_room_select")

func go_to_campfire():
	GameState.room_cleared()
	GameState.change_scene(GameState.SCENES["campfire"])
	
func go_to_room_select():
	GameState.room_cleared()
	GameState.change_scene(GameState.SCENES["room_selection"])
