extends Control

@export var bus_name: String
var bus_index: int

@onready var button_container: Panel = $ButtonContainer
@onready var blur_screen: ColorRect = $"Blur Screen"
@onready var settings_panel: Panel = $SettingsPanel
@onready var volume_slider: HSlider = $SettingsPanel/VBoxContainer/HBoxContainer/VolumeSlider

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	volume_slider.value_changed.connect(_on_value_changed)
	GlobalAudioStreamPlayer.play_title_music()
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))

func _on_play_button_pressed() -> void:
	GameState.change_scene(GameState.SCENES["lobby"])

func _on_continue_button_pressed() -> void:
	GameState.load_game()
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
