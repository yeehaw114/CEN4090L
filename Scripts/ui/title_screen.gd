extends Control

@onready var button_container: Panel = $ButtonContainer
@onready var blur_screen: ColorRect = $"Blur Screen"
@onready var settings_panel: Panel = $SettingsPanel

func _on_play_button_pressed() -> void:
	GameState.change_scene(GameState.SCENES["lobby"])

func _on_settings_button_pressed() -> void:
	button_container.hide()
	blur_screen.show()
	settings_panel.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_quit_button_pressed() -> void:
	button_container.show()
	blur_screen.hide()
	settings_panel.hide()
