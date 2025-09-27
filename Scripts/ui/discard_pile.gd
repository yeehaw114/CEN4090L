extends Node2D

var discarded_cards: Array[Card]
@onready var discard_spawn: Node2D = $Discard_spawn
@onready var discard_count: Label = $DiscardCount

signal card_discarded(card: Card)

func print_all_discarded_cards() -> void:
	for card in discarded_cards:
		print(str(card))
		pass
	print()
	
func move_card_to_discard(card: Card) ->void:
	card.position = discard_spawn.position
	card_discarded.emit(card)
	discard_count.text = str(discarded_cards.size())
	
func get_discarded_cards_resource() -> Array[Card]:
	return discarded_cards
