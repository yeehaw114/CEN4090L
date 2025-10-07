extends Node2D

var discarded_cards: Array[CardResource]
@onready var discard_spawn: Node2D = $Discard_spawn
@onready var discard_count: Label = $DiscardCount

signal card_discarded(card: Card)
signal update_display_card_deck(cards: Array[CardResource])

func _ready() -> void:
	print("Discard pile node:", self.name, "ID:", get_instance_id())

func print_all_discarded_cards() -> void:
	for card in discarded_cards:
		print(str(card))
	print()
	
func move_card_to_discard(card: Card) ->void:
	var stats_copy = card.card_stats.duplicate(true)
	print("Moving card", card.get_instance_id(), "Stats ID:", stats_copy.get_instance_id())
	discarded_cards.append(stats_copy)
	discard_count.text = str(discarded_cards.size())
	
	update_display_card_deck.emit(discarded_cards)
	
	card.reparent(self)
	card.queue_free()
	
func get_discarded_cards() -> Array[CardResource]:
	return discarded_cards

func move_all_cards_to_discard(cards: Array[Node]):
	for card in cards:
		move_card_to_discard(card)

func update_count():
	discard_count.text = str(discarded_cards.size())
