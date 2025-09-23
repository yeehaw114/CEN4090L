extends Node2D

func _ready() -> void:
	GameState.battle_scene = load("res://Scenes/battle_manager.tscn").instantiate()
	GameState.display_deck_scene = load("res://Scenes/display_card_deck.tscn").instantiate()
	
	# Add scenes to the root once
	get_tree().root.add_child(GameState.battle_scene)
	get_tree().root.add_child(GameState.display_deck_scene)
	print(GameState.battle_scene)
	GameState.battle_scene.show()
	GameState.display_deck_scene.hide()
	get_tree().current_scene = GameState.battle_scene
	
