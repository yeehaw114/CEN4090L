extends Node2D

var discarded_cards: Array[CardResource]
@onready var discard_spawn: Node2D = $Discard_spawn
@onready var discard_count: Label = $DiscardCount

signal card_discarded(card: Card)
signal update_display_card_deck(cards: Array[CardResource])

func print_all_discarded_cards() -> void:
	for card in discarded_cards:
		print(str(card))
	print()
	
func move_card_to_discard(card: Card) ->void:
	var stats_copy = card.card_stats.duplicate(true)
	discarded_cards.append(stats_copy)
	discard_count.text = str(discarded_cards.size())
	card_discarded.emit(stats_copy)
	card.reparent(self)
	card.queue_free()
	
func get_discarded_cards() -> Array[CardResource]:
	return discarded_cards

func move_all_cards_to_discard(cards: Array[Node]):
	for card in cards:
		move_card_to_discard(card)

func update_count():
	discard_count.text = str(discarded_cards.size())
