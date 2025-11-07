extends Control

@onready var button_a: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/RoomButtonA
@onready var button_b: Button = $VBoxContainer/Panel2/MarginContainer/VBoxContainer/RoomButtonB
@onready var button_c: Button = $VBoxContainer/Panel3/MarginContainer/VBoxContainer/RoomButtonC

@onready var panel: Panel = $VBoxContainer/Panel
@onready var panel_2: Panel = $VBoxContainer/Panel2
@onready var panel_3: Panel = $VBoxContainer/Panel3
@onready var panel_nodes = [panel, panel_2, panel_3]

var room_paths = ["res://Scenes/SmallRoom.tscn","res://Scenes/MediumRoom.tscn","res://Scenes/LargeRoom.tscn"]

var boss_room_path = "res://Scenes/boss_room.tscn"

const run_room_paths = "res://Scenes/RunRooms/"
var selected_rooms: Array = [] # holds { "path": ..., "name": ..., "description": ... }

var boss_time := false

func _ready():
	GameState.preload_run_scenes()
	get_room_paths()
	print(room_paths)
	
	call_deferred("set_panel_visuals")
	
	if GameState.boss_time:
		boss_time = true
		call_deferred("set_boss_select")
	
	button_a.pressed.connect(_on_room_selected.bind("A"))
	button_b.pressed.connect(_on_room_selected.bind("B"))
	button_c.pressed.connect(_on_room_selected.bind("C"))

func get_room_paths():
	var dir = DirAccess.open(run_room_paths)
	if not dir:
		push_error("Failed to open directory: " + run_room_paths)
		return

	var all_rooms: Array = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			all_rooms.append(run_room_paths + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if all_rooms.is_empty():
		push_warning("No rooms found in: " + run_room_paths)
		return

	all_rooms.shuffle() # randomize order

	var chosen = all_rooms.slice(0, 3) # pick 3 random rooms
	room_paths = chosen                 # store paths if you still use them elsewhere
	selected_rooms.clear()

	for path in chosen:
		var scene = load(path)
		if scene and scene is PackedScene:
			var instance = scene.instantiate()
			selected_rooms.append({
				"path": path,
				"name": instance.room_name,
				"danger": instance.danger
			})
			instance.queue_free()

func set_panel_visuals():
	var index := 0
	for panel in panel_nodes:
		panel.set_values(selected_rooms[index].name,selected_rooms[index].danger)
		index += 1
	

func _on_room_selected(room_id):
	print("Selected room:", room_id)
	var room_path = ""
	match room_id:
		"A":
			room_path = room_paths[0]
		"B":
			room_path = room_paths[1]
		"C":
			room_path = room_paths[2]
			if boss_time:
				room_path = boss_room_path

	GameState.change_scene(room_path)

func set_boss_select():
	panel.hide()
	panel_2.hide()
	panel_3.set_values("Bear den","Extreme")
