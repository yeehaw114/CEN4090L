extends Control

@onready var button_a: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/RoomButtonA

@onready var button_b: Button = $VBoxContainer/Panel2/MarginContainer/VBoxContainer/RoomButtonB

@onready var button_c: Button = $VBoxContainer/Panel3/MarginContainer/VBoxContainer/RoomButtonC


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
