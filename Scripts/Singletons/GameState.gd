extends Node

var transferred_cards = []
var battle_scene: Control = null
var display_deck_scene: Control = null

func clear():
	transferred_cards = []
	

var current_scene_path: String = ""
var rooms_cleared: int = 0
var total_rooms: int = 10
var player_alive: bool = true
var run_active: bool = false

const SCENES := {
	"lobby": "res://Scenes/Lobby.tscn",
	"bunker": "res://Scenes/Bunker.tscn",
	"room_selection": "res://Scenes/RoomSelection.tscn",
	"small_room": "res://Scenes/SmallRoom.tscn",
	"medium_room": "res://Scenes/MediumRoom.tscn",
	"large_room": "res://Scenes/LargeRoom.tscn",
	"campfire": "res://Scenes/Campfire.tscn",
	"battle": "res://Scenes/battle_manager.tscn",
	"boss": "res://Scenes/BossRoom.tscn"
}


func change_scene(scene_path: String):
	if not ResourceLoader.exists(scene_path):
		push_warning("Scene not found: " + scene_path)
		return
	get_tree().call_deferred("change_scene_to_file", scene_path)
	current_scene_path = scene_path

func reset_run():
	rooms_cleared = 0
	player_alive = true
	run_active = false

func start_run():
	run_active = true
	rooms_cleared = 0
	player_alive = true

func room_cleared():
	rooms_cleared += 1

func player_died():
	player_alive = false
	change_scene(SCENES["lobby"])
