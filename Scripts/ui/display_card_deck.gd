extends Control

@export var card_scene: PackedScene = preload("res://Scenes/card.tscn")
@export var grid_width: int = 5      # how many columns
@export var cell_size: Vector2 = Vector2(96, 144)

@onready var grid_container: GridContainer = $VBoxContainer/MarginContainer/GridContainer

var cards: Array[Card]
var stats_list : Array[CardResource]

signal exit_button_clicked()

func set_stats_list():
	for card in cards:
		stats_list.append(card.card_stats)

func _ready():
	pass

func populate_grid():
	set_stats_list()
	clear_grid()
	print(cards)
	for card_stat in stats_list:
		var new_card = card_scene.instantiate()
		new_card.card_stats = card_stat
		grid_container.add_child(new_card)
	print()
	stats_list = []
	
func clear_grid():
	for card in grid_container.get_children():
		card.queue_free()

func set_display_cards() -> void:
	pass

func _on_exit_button_pressed() -> void:
	clear_grid()
	exit_button_clicked.emit()


func _on_discard_pile_card_discarded(card: Card) -> void:
	cards.append(card)
