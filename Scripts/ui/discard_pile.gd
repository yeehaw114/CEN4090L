extends Node2D

var discarded_cards: Array[Card]
@onready var discard_spawn: Node2D = $Discard_spawn
@onready var discard_count: Label = $DiscardCount

func print_all_discarded_cards() -> void:
	for card in discarded_cards:
		#print(str(card))
		pass
	#print()

func move_cards_to_discard() -> void:
	var count: int = 0
	for card in discarded_cards:
		card.position = discard_spawn.position
		count += 1
	discard_count.text = str(count)
	
