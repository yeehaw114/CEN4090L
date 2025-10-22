extends Control

func _on_button_pressed() -> void:
	print('ATTEMPT TO RETURN TO: '+str(GameState.previous_scene))
	GameState.return_to_previous_scene_live()
