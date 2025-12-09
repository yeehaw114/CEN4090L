extends Area2D

@onready var click_icon = $IconPosition/ClickIcon
var player_nearby = false
var dialogue_box = null
var player = null

# Define your NPC's dialogue here
var dialogue_lines = [
	"Hello there traveller, welcome to the lobby! I'm here to help you get started.",
	"Here you can look at your card collection, buy new cards at the shop, and begin your adventure by entering the bunker.",
	"When you enter the bunker you will have to venture deeper into the forest until you find the corrupted bear, then you can defeat him!",
	"Be on the lookout for chests around the forest, be careful of enemies you may encounter, and if you ever feel like you may die you can end your run in any campfire room.",
	"Good luck little mouse, you may come back anytime to hear this again."
]

func _ready():
	# Connect the Area2D signals to detect player proximity
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	$AnimatedSprite2D.play("default")
	
	# Make sure icon is hidden at start (check if it exists first)
	if click_icon:
		click_icon.visible = false
	else:
		push_error("ClickIcon not found! Check node path: IconPosition/ClickIcon")
	
	# Find the dialogue box in the scene (adjust the path if needed)
	await get_tree().process_frame  # Wait for scene to be fully loaded
	dialogue_box = get_tree().get_first_node_in_group("dialogue_box")
	if not dialogue_box:
		push_error("DialogueBox not found! Make sure it's in the 'dialogue_box' group")
	else:
		# Connect to dialogue finished signal
		dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_body_entered(body):
	# Check if the body that entered is the player
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = true
		player = body  # Store reference to player
		if click_icon:
			click_icon.visible = true

func _on_body_exited(body):
	# Check if the body that exited is the player
	if body.name == "Player" or body.is_in_group("player"):
		player_nearby = false
		if click_icon:
			click_icon.visible = false

func _input(event):
	if player_nearby and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if dialogue_box and not dialogue_box.visible:
				start_dialogue()

func start_dialogue():
	if dialogue_box:
		dialogue_box.start_dialogue(dialogue_lines)
		if click_icon:
			click_icon.visible = false
		
		# Freeze the player using your existing function
		if player and player.has_method("toggle_able_to_move"):
			player.toggle_able_to_move(false)

func _on_dialogue_finished():
	# Unfreeze the player when dialogue ends
	if player and player.has_method("toggle_able_to_move"):
		player.toggle_able_to_move(true)
