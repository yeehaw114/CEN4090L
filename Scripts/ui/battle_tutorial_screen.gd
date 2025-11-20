extends Control

@onready var card: Card = $Panel/MarginContainer/ScrollContainer/VBoxContainer/Card

const card_example := preload("res://Assets/Resources/cards/final_cards/Pierce_card.tres")

signal pause_game(toggle: bool)

func _ready() -> void:
	card.card_stats = card_example
	card.is_able_to_be_selected = false
	card.set_values()


func _on_exit_button_pressed() -> void:
	pause_game.emit()
