extends CanvasLayer

# References to UI elements
@onready var panel = $Panel
@onready var npc_portrait = $Panel/MarginContainer/HBoxContainer/NPCPortrait
@onready var npc_name_label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/NPCName
@onready var dialogue_label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/DialogueText

# Dialogue data
var dialogue_lines: Array = []
var current_line_index: int = 0

# Text animation
var is_animating: bool = false
var current_text: String = ""
var char_index: int = 0
var text_speed: float = 0.05  # seconds per character

# Timer for letter-by-letter
var text_timer: float = 0.0

func _ready():
	hide()  # Hide by default
	set_process(false)  # Don't process until dialogue starts

func start_dialogue(npc_name: String, lines: Array, portrait: Texture2D = null):
	"""Start a new dialogue sequence"""
	dialogue_lines = lines
	current_line_index = 0
	
	# Set NPC info
	npc_name_label.text = npc_name
	if portrait:
		npc_portrait.texture = portrait
	else:
		npc_portrait.hide()
	
	# Show dialogue box
	show()
	set_process(true)
	
	# Start first line
	display_line()

func display_line():
	"""Display the current dialogue line with letter-by-letter animation"""
	if current_line_index >= dialogue_lines.size():
		end_dialogue()
		return
	
	current_text = dialogue_lines[current_line_index]
	char_index = 0
	is_animating = true
	dialogue_label.text = ""
	text_timer = 0.0

func _process(delta):
	if is_animating:
		text_timer += delta
		
		# Add characters based on timer
		while text_timer >= text_speed and char_index < current_text.length():
			dialogue_label.text += current_text[char_index]
			char_index += 1
			text_timer -= text_speed
		
		# Check if animation is complete
		if char_index >= current_text.length():
			is_animating = false

func _input(event):
	if not visible:
		return
	
	# Check for mouse click or action press
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_input()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		handle_input()

func handle_input():
	"""Handle player clicking to advance dialogue"""
	if is_animating:
		# Skip to end of current line
		dialogue_label.text = current_text
		char_index = current_text.length()
		is_animating = false
	else:
		# Move to next line
		current_line_index += 1
		display_line()

func end_dialogue():
	"""Close the dialogue box"""
	hide()
	set_process(false)
	dialogue_lines.clear()
	current_line_index = 0
	dialogue_label.text = ""
	
	# Re-enable player movement
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("toggle_able_to_move"):
		player.toggle_able_to_move(true)

func is_dialogue_active() -> bool:
	"""Check if dialogue is currently showing"""
	return visible
