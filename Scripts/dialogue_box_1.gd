extends Control

@onready var dialogue_label = $DialoguePanel/MarginContainer/HBoxContainer/DialogueLabel
@onready var npc_portrait = $DialoguePanel/MarginContainer/HBoxContainer/NPCPortrait

var dialogue_lines = []  # Array of dialogue sentences
var current_line_index = 0
var current_text = ""
var char_index = 0
var is_typing = false
var typing_speed = 0.05  # Seconds per character

signal dialogue_finished

func _ready():
	visible = false

func start_dialogue(lines: Array, portrait_texture: Texture2D = null):
	dialogue_lines = lines
	current_line_index = 0
	visible = true
	
	# Set the NPC portrait if provided
	if portrait_texture:
		npc_portrait.texture = portrait_texture
	
	# Start displaying the first line
	display_next_line()

func display_next_line():
	if current_line_index >= dialogue_lines.size():
		# All lines finished, close dialogue
		end_dialogue()
		return
	
	current_text = dialogue_lines[current_line_index]
	char_index = 0
	dialogue_label.text = ""
	is_typing = true
	type_text()

func type_text():
	if char_index < current_text.length():
		dialogue_label.text += current_text[char_index]
		char_index += 1
		await get_tree().create_timer(typing_speed).timeout
		if is_typing:  # Check if we haven't been interrupted
			type_text()
	else:
		is_typing = false

func skip_typing():
	if is_typing:
		# Skip to end of current sentence
		is_typing = false
		dialogue_label.text = current_text
	else:
		# Move to next line
		current_line_index += 1
		display_next_line()

func _input(event):
	if visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			skip_typing()

func end_dialogue():
	visible = false
	dialogue_finished.emit()
