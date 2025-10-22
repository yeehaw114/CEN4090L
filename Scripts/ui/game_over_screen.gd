extends Control

func _on_button_pressed() -> void:
	GameState.change_scene(GameState.SCENES["lobby"])
