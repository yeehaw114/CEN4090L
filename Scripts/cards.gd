extends Node

@onready var discard_pile: Node2D = $DiscardPile
@onready var draw_pile: Node2D = $DrawPile

@onready var hand_area: ColorRect = $HandArea

@export var card_scene: PackedScene = preload("res://Scenes/card.tscn")

var cards: Array = []
var currently_selected_card: Card

signal card_selected(card_data: Array)
signal card_unselected
signal reward_card_selected

const CARD_Y_FACTOR := 25
const CARD_SCALE_FACTOR := 0.7

func _ready() -> void:
	#print(card_debug.card_stats)
	set_cards()
	hand_area.update_cards()

func attempt_to_select_card():
	var card = raycast_check_for_card()
	if card != null and card != currently_selected_card and card.is_able_to_be_selected and !card.is_reward:
		if currently_selected_card != null:
			unhighlight_selected_card(currently_selected_card)
			card_unselected.emit()
			currently_selected_card.is_currently_selected = false
		currently_selected_card = card
		currently_selected_card.is_currently_selected = true
		card_selected.emit([card.card_stats.character_position,
							card.card_stats.enemy_position])
		highlight_selected_card(currently_selected_card)
	elif card != null and card.is_able_to_be_selected and card.is_reward:
		GameState.transferred_cards.append(card.card_stats.duplicate(true))
		reward_card_selected.emit()
		print('REWARD CARD SELECTED: '+str(card))

func raycast_check_for_card():
	print("RAYCAST FOR CARDS")
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1

	var results = space_state.intersect_point(parameters)

	for hit in results:
		var collider = hit.collider
		if collider is Area2D:
			var node = collider
			while node:
				if node.is_in_group("Card"):
					print("CLICKED ON CARD:", node)
					return node
				node = node.get_parent()

	print("NO CARD CLICKED")
	return null

func set_cards():
	for c in hand_area.get_children():
		cards.append(c)
		
func get_card_player_data(card: CardResource) -> Array[CardResource.rank]:
	return card.character_position
	
func get_card_enemy_data(card: CardResource) -> Array[CardResource.rank]:
	return card.enemy_position
	
func highlight_selected_card(card: Card):
	card.position.y -= CARD_Y_FACTOR
	card.increase_scale(CARD_SCALE_FACTOR)

func unhighlight_selected_card(card: Card):
	if card:
		card.position.y += CARD_Y_FACTOR
		card.decrease_scale(CARD_SCALE_FACTOR)

func unselect_card():
	if currently_selected_card:
		unhighlight_selected_card(currently_selected_card)
		card_unselected.emit()
		currently_selected_card = null
	
func draw_one_card():
	var draw_pile_cards = draw_pile.draw_cards
	if draw_pile_cards.size() < 1:
		print('need more cards')
		move_discard_cards_to_draw()
		draw_pile_cards = draw_pile.draw_cards
		draw_pile.update_display_card_deck.emit(draw_pile_cards)
	var top_card = draw_pile_cards.pop_front()
	if top_card:
		var new_card = card_scene.instantiate()
		new_card.card_stats = top_card.duplicate(true)
		print("Drawn card ID:", new_card.get_instance_id(), 
	  "Stats ID:", new_card.card_stats.get_instance_id())
		hand_area.add_child(new_card)
		draw_pile.update_count()
	hand_area.update_cards()

func draw_cards(num: int):
	for n in num:
		draw_one_card()
	hand_area.update_cards()

func discard_all_cards():
	var cards_to_be_discarded = hand_area.get_cards()
	discard_pile.move_all_cards_to_discard(cards_to_be_discarded)

func move_discard_cards_to_draw():
	var discard_card_stats : Array[CardResource] = []
	for card_stats in discard_pile.get_discarded_cards():
		discard_card_stats.append(card_stats.duplicate(true))
	draw_pile.draw_cards = discard_card_stats
	discard_pile.discarded_cards.clear()
	
	draw_pile.shuffle_draw_cards()
	
	draw_pile.update_display_card_deck.emit(draw_pile.draw_cards)
	draw_pile.update_count()
	discard_pile.update_display_card_deck.emit(discard_pile.discarded_cards)
	discard_pile.update_count()
	print('ATTEMPT TO MOVE CARDS FROM DISCARD TO DRAW')
	print('DRAW PILE: '+str(draw_pile.draw_cards))
	print('DISCARD PILE: '+str(discard_pile.discarded_cards))

func make_cards_in_hand_unselectable():
	print('\nATTEMPTING TO MAKE CARDS UNSELECTABLE: '+str(hand_area.get_cards())+'\n')
	for card in hand_area.get_cards():
		card.is_able_to_be_selected = false

func make_cards_in_hand_selectable():
	for card in hand_area.get_cards():
		card.is_able_to_be_selected = true
