extends Control

@export var card_scene: PackedScene = preload("res://Scenes/card.tscn")
@export var grid_width: int = 5      # how many columns
@export var cell_size: Vector2 = Vector2(96, 144)

@onready var grid_container: GridContainer = $VBoxContainer/MarginContainer/GridContainer
@onready var discard_pile: Node2D = $"../BattleManager/Cards/DiscardPile"

var cards: Array[Card]
var stats_list : Array[CardResource]

signal exit_button_clicked()

func _ready():
	pass

func populate_grid():
	clear_grid()
	print('DISPLAY DISCARD DECK\n'+str(stats_list))
	for card_stat in stats_list:
		var new_card = card_scene.instantiate()
		new_card.card_stats = card_stat
		new_card.is_able_to_be_selected = false
		grid_container.add_child(new_card)
	print()
	
func clear_grid():
	for card in grid_container.get_children():
		card.queue_free()

func set_display_cards() -> void:
	pass

func _on_exit_button_pressed() -> void:
	clear_grid()
	exit_button_clicked.emit()

func _on_discard_pile_card_discarded(card: CardResource) -> void:
	print("Signal received with Stats ID:", card.get_instance_id())
	print('appending card to stats list')
	print('STATS_LIST_BEFORE: '+str(stats_list))
	stats_list.append(card)
	print('STATS_LIST: '+str(stats_list))
	print(card)

func _on_discard_pile_update_display_card_deck(cards: Array[CardResource]) -> void:
	stats_list = cards
	print('UPDATED DISCARD STATS_LIST: '+str(stats_list))

func get_stats_list():
	return stats_list
