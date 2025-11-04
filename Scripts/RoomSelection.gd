extends Control

@onready var button_a: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/RoomButtonA
@onready var button_b: Button = $VBoxContainer/Panel2/MarginContainer/VBoxContainer/RoomButtonB
@onready var button_c: Button = $VBoxContainer/Panel3/MarginContainer/VBoxContainer/RoomButtonC

@onready var panel: Panel = $VBoxContainer/Panel
@onready var panel_2: Panel = $VBoxContainer/Panel2
@onready var panel_3: Panel = $VBoxContainer/Panel3

var room_paths = ["res://Scenes/SmallRoom.tscn","res://Scenes/MediumRoom.tscn","res://Scenes/LargeRoom.tscn"]
var boss_room_path = "res://Scenes/boss_room.tscn"

var boss_time := false

func _ready():
	GameState.preload_run_scenes()
	
	if GameState.rooms_cleared >= 1:
		boss_time = true
		set_boss_select(boss_room_path)
	
	button_a.pressed.connect(_on_room_selected.bind("A"))
	button_b.pressed.connect(_on_room_selected.bind("B"))
	button_c.pressed.connect(_on_room_selected.bind("C"))

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

func set_boss_select(boss_room_path):
	panel.hide()
	panel_2.hide()
