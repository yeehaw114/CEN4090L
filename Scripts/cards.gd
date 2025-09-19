extends Node

@onready var discard_pile: Node2D = $DiscardPile
@onready var hand_area: ColorRect = $HandArea

var cards: Array = []
var currently_selected_card: Card

const CARD_Y_FACTOR := 25
const CARD_SCALE_FACTOR := 0.7


func _ready() -> void:
	set_cards()

func attempt_to_select_card():
	var card = raycast_check_for_card()
	if card != null and card != currently_selected_card:
		if currently_selected_card != null:
			unhighlight_selected_card(currently_selected_card)
			currently_selected_card.is_currently_selected = false
		currently_selected_card = card
		currently_selected_card.is_currently_selected = true
		highlight_selected_card(currently_selected_card)
		#print('currently_selected_card: '+str(currently_selected_card))

func raycast_check_for_card():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		if result[0].collider.get_parent().is_in_group("Card"):
			return result[0].collider.get_parent()
	return null

func set_cards():
	for c in hand_area.get_children():
		cards.append(c)
		
func highlight_selected_card(card: Card):
	card.position.y -= CARD_Y_FACTOR
	card.increase_scale(CARD_SCALE_FACTOR)

func unhighlight_selected_card(card: Card):
	if card:
		card.position.y += CARD_Y_FACTOR
		card.decrease_scale(CARD_SCALE_FACTOR)

func unselect_card():
	unhighlight_selected_card(currently_selected_card)
	currently_selected_card = null
	
