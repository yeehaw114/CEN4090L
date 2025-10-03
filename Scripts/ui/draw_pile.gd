extends Node2D

@export var draw_cards: Array[CardResource]
@onready var discard_spawn: Node2D = $Discard_spawn
@onready var discard_count: Label = $DiscardCount

signal card_discarded(card: Card)
signal update_display_card_deck(cards: Array[CardResource])

func _ready() -> void:
	discard_count.text = str(draw_cards.size())
	update_display_card_deck.emit(draw_cards)

func print_all_discarded_cards() -> void:
	for card in draw_cards:
		print(str(card))
		pass
	print()
	
func move_card_to_discard(card: Card) ->void:
	card.position = discard_spawn.position
	card_discarded.emit(card)
	discard_count.text = str(draw_cards.size())
	
func get_discarded_cards_resource() -> Array[CardResource]:
	return draw_cards

func update_count():
	discard_count.text = str(draw_cards.size())
	
func get_draw_cards() -> Array[CardResource]:
	return draw_cards
