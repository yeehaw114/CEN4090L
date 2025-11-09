extends Node

var strike = load("res://Assets/Resources/cards/strike_card.tres")
var defend = load("res://Assets/Resources/cards/defend_card.tres")
var default_cards : Array[CardResource] = [strike,strike,strike,strike,defend,defend]

# Existing data from your game
var coins := 20
var coins_current := 0
var max_health := 20
var current_health := 20

var transferred_cards := default_cards.duplicate(true)
var battle_scene: Control = null
var display_deck_scene: Control = null

func clear():
	transferred_cards = []

# --- Persistent run data ---
var current_scene_path: String = ""
var previous_scene: Node
var pending_battle_resource: BattleResource = null
var rooms_cleared: int = 0
var total_rooms: int = 10
var boss_time := false
var player_alive: bool = true
var run_active: bool = false

# --- Scene registry ---
const SCENES := {
	"lobby": "res://Scenes/lobby.tscn",
	"bunker": "res://Scenes/Bunker.tscn",
	"room_selection": "res://Scenes/RoomSelection.tscn",
	"small_room": "res://Scenes/SmallRoom.tscn",
	"medium_room": "res://Scenes/MediumRoom.tscn",
	"large_room": "res://Scenes/LargeRoom.tscn",
	"campfire": "res://Scenes/Campfire.tscn",
	"battle": "res://Scenes/battle_manager.tscn",
	"boss": "res://Scenes/boss_room.tscn"
}

func save():
	var card_data = []
	for card in CardCollection.all_cards:
		card_data.append(card.to_dict())

	var save_dict = {
		"coins": coins,
		"cards": card_data
	}

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict, "\t"))
	file.close()

func load_game():
	print('attempting to load game')
	if not FileAccess.file_exists("user://savegame.json"):
		print('failed to load game')
		return

	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) == TYPE_DICTIONARY:
		coins = data.get("coins", 0)
		
		for card_info in data.get("cards", []):
			for card in CardCollection.all_cards:
				if card.card_name == card_info.get("card_name"):
					card.from_dict(card_info)


# --- Cached preloaded scenes ---
var cached_scenes: Dictionary = {}

# --- Core: Safe scene changing ---
func change_scene(scene_path: String):
	# If we have this scene already cached, use the preloaded version
	for key in cached_scenes.keys():
		if SCENES[key] == scene_path:
			if scene_path == GameState.SCENES["lobby"]:
				GlobalAudioStreamPlayer.play_lobby_music()
				rooms_cleared = 0
				boss_time = false
				if player_alive:
					coins += coins_current
				coins_current = 0
				current_health = max_health
				player_alive = true
				transferred_cards = default_cards.duplicate(true)
				
				print('\nCLEARING ROOMS CLEARED\n')
			get_tree().call_deferred("change_scene_to_packed", cached_scenes[key])
			current_scene_path = scene_path
			return

	# Otherwise, load normally
	if not ResourceLoader.exists(scene_path):
		push_warning("Scene not found: " + scene_path)
		return
	get_tree().call_deferred("change_scene_to_file", scene_path)
	current_scene_path = scene_path

func return_to_previous_scene_live():
	var tree := get_tree()

	# Make sure we have a valid stored scene
	if not previous_scene or not is_instance_valid(previous_scene):
		push_warning("No valid live scene stored.")
		return

	# Ensure the current scene exists before trying to remove it
	var current_scene := tree.current_scene
	if current_scene and is_instance_valid(current_scene):
		tree.root.remove_child(current_scene)
		current_scene.queue_free()
	else:
		print("No valid current scene to free (may already be removed).")

	# Reattach the previous live scene
	tree.root.add_child(previous_scene)
	tree.current_scene = previous_scene
	GlobalAudioStreamPlayer.play_dungeon_music()
	current_scene_path = ""  # optional, since this is a live restore

	print("Returned to live previous scene:", previous_scene.name)

# --- Lifecycle helpers ---
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
	if rooms_cleared == total_rooms-1:
		boss_time = true

func player_died():
	player_alive = false
	change_scene(SCENES["lobby"])

func heal(value: int):
	current_health += value
	if current_health > max_health:
		current_health = max_health

# --- NEW SECTION: Dynamic loading & unloading ---

func _ready():
	# Load core hub scenes once when game boots
	preload_hub_scenes()

func preload_hub_scenes():
	for id in ["lobby", "bunker", "room_selection"]:
		if SCENES.has(id):
			# ResourceLoader.load() works with variable paths
			var packed_scene = ResourceLoader.load(SCENES[id])
			if packed_scene:
				cached_scenes[id] = packed_scene
	print("Hub scenes loaded into memory.")

func unload_hub_scenes():
	for id in ["lobby", "bunker"]:
		cached_scenes.erase(id)
	print("Hub scenes freed to save memory.")

func preload_run_scenes():
	for id in ["campfire"]:
		if SCENES.has(id):
			var path = SCENES[id]
			print("Preloading:", path)
			var packed_scene = ResourceLoader.load(path)
			if packed_scene:
				cached_scenes[id] = packed_scene
				print(id, "loaded and cached successfully.")
			else:
				push_warning("Failed to load: " + path)
	print("Campfire preload attempt complete. Cached keys:", cached_scenes.keys())

func unload_run_scenes():
	for id in ["small_room", "medium_room", "large_room", "campfire"]:
		cached_scenes.erase(id)
	print("Run scenes cleared from memory.")
	preload_hub_scenes() # restore hub scenes for next run
