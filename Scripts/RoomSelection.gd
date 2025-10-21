extends Control

@onready var button_a = $VBoxContainer/RoomButtonA
@onready var button_b = $VBoxContainer/RoomButtonB
@onready var button_c = $VBoxContainer/RoomButtonC

func _ready():
	GameState.preload_run_scenes()
	button_a.pressed.connect(_on_room_selected.bind("A"))
	button_b.pressed.connect(_on_room_selected.bind("B"))
	button_c.pressed.connect(_on_room_selected.bind("C"))

func _on_room_selected(room_id):
	print("Selected room:", room_id)
	
	var room_path = ""
	match room_id:
		"A":
			room_path = "res://Scenes/SmallRoom.tscn"
		"B":
			room_path = "res://Scenes/MediumRoom.tscn"
		"C":
			room_path = "res://Scenes/LargeRoom.tscn"

	GameState.change_scene(room_path)
