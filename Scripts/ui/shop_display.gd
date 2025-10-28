extends Control

@onready var card_left: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Card
@onready var card_middle: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/Card
@onready var card_right: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/Card

var card_resources : Array[CardResource] = []
signal toggle_display(toggle: bool)

func update_card_resources(cards : Array[CardResource]):
	card_resources = cards

func update_cards(card_resources : Array[CardResource]):
	card_resources.shuffle()
	card_left.card_stats = card_resources.pop_front()
	card_left.set_values()
	card_middle.card_stats = card_resources.pop_front()
	card_middle.set_values()
	card_right.card_stats = card_resources.pop_front()
	card_right.set_values()

func _on_exit_button_pressed() -> void:
	hide()
	toggle_display.emit(true)

func _on_shop_object_interacted_with() -> void:
	show()
	toggle_display.emit(false)
