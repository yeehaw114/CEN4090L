extends Node2D

var discarded_cards: Array[Card]
@onready var discard_spawn: Node2D = $Discard_spawn

func print_all_discarded_cards() -> void:
	for card in discarded_cards:
		print(str(card))
	print()

func move_cards_to_discard() -> void:
	for card in discarded_cards:
		card.position = discard_spawn.position
