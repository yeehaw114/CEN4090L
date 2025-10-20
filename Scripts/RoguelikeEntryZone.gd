extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		change_to_room_selection()

func change_to_room_selection():
	# Defer scene change explicitly and add a tiny yield to exit physics step.
	await get_tree().process_frame
	GameState.change_scene(GameState.SCENES["room_selection"])
