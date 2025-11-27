extends Control

@onready var storage_options_panel: Panel = $StorageOptionsPanel
@onready var storage_panel: Panel = $StoragePanel

func _on_exit_button_pressed() -> void:
	hide()
