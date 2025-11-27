extends Control

@onready var bar_panel: Panel = $BarPanel
@onready var bar_options_panel: Panel = $BarOptionsPanel

func _on_exit_button_pressed() -> void:
	hide()

func _on_drink_button_pressed() -> void:
	if PlayerInventory.spend_coins(5):
		PlayerInventory.heal_nerve(30)

func _on_talk_button_pressed() -> void:
	pass # Replace with function body.
