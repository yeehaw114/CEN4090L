extends Area2D

@export var dialogue_box_path: NodePath
@onready var dialogue_box: Control = get_node(dialogue_box_path) as Control
@onready var click_icon = $IconPosition/ClickIcon
var player_nearby = false
var player = null

# Define your NPC's dialogue here
var dialogue_lines = [
	"The corruption is not a plague. It is a presence, something that learned to live where it should have died.",
	"The corruption is not born of flesh. It is a thought that learned to hunger, an old malice with no face of its own.",
	"If you face it, do not bargain. It knows your voice will tremble.",
	"It doesn’t simply twist flesh… it nests behind the eyes, filling the mind with torment and rage until the creature forgets what mercy feels like.",
	"And so the forest waits, holding its breath for a true knight to cut the blackness out by the root, and teach the wild to be whole again."
]

func _ready():
	# Connect the Area2D signals to detect player proximity
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Make sure icon is hidden at start (check if it exists first)
	if click_icon:
		click_icon.visible = false
	else:
		push_error("ClickIcon not found! Check node path: IconPosition/ClickIcon")
	
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
