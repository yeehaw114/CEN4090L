extends Node

@onready var discard_pile: Node2D = $DiscardPile

var cards: Array = []
var currently_selected_card: Card

signal card_clicked(card: Card)

func _ready() -> void:
	set_cards()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card != null and card != currently_selected_card:
				card_clicked.emit(card)
				if currently_selected_card != null:
					currently_selected_card.reset_scale_and_position()
					currently_selected_card.is_currently_selected = false
				currently_selected_card = card
				currently_selected_card.is_currently_selected = true
				highlight_selected_card(currently_selected_card)
		else:
			pass
			
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
	for c in get_children():
		cards.append(c)
		
func highlight_selected_card(card: Card):
	card.position.y -= 15
	card.increase_scale(0.5)
