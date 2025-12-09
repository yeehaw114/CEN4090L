extends Control

@export var bus_name: String
var bus_index: int

@onready var un_pause_button: Button = $PausePanel/VBoxContainer/UnPauseButton
@onready var settings_button: Button = $PausePanel/VBoxContainer/SettingsButton
@onready var quit_button: Button = $PausePanel/VBoxContainer/QuitButton

@onready var settings_panel: Panel = $SettingsPanel
@onready var quit_loss_progress_panel: Panel = $QuitLossProgressPanel
@onready var volume_silder: HSlider = $SettingsPanel/VBoxContainer/HBoxContainer/VolumeSilder

signal pause_game(toggle: bool)

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	volume_silder.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))

func _on_un_pause_button_pressed() -> void:
	pause_game.emit(false)
	settings_panel.hide()
	quit_loss_progress_panel.hide()

func reset_panels_to_default():
	settings_panel.hide()
	quit_loss_progress_panel.hide()
	un_pause_button.disabled = false
	settings_button.disabled = false
	quit_button.disabled = false

func _on_settings_button_pressed() -> void:
	settings_panel.show()
	un_pause_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true


func _on_quit_button_pressed() -> void:
	quit_loss_progress_panel.show()
	un_pause_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true


func _on_quit_settings_button_pressed() -> void:
	settings_panel.hide()
	un_pause_button.disabled = false
	settings_button.disabled = false
	quit_button.disabled = false


func _on_cancel_quit_button_pressed() -> void:
	quit_loss_progress_panel.hide()
	un_pause_button.disabled = false
	settings_button.disabled = false
	quit_button.disabled = false


func _on_confirm_quit_button_pressed() -> void:
	GameState.save()
	get_tree().quit()
