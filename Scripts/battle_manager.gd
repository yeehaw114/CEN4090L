extends Node2D
@onready var enemies_node: Node = $Enemies
@onready var cards: Node = $Cards

@export var player: Character
@export var enemy: Character
#var current_character: Character
var currently_selected_enemy: Character

var game_over: bool = false

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var char = raycast_check_for_character()
			if char != null and cards.currently_selected_card != null:
				currently_selected_enemy = char
				#print('using '+str(cards.currently_selected_card)+' on '+str(char))
				cast_card_on_character(cards.currently_selected_card,currently_selected_enemy)

func next_turn():
	if game_over:
		return

func select_character():
	var e: Character

func _on_card_selected(card: Card) -> void:
	cards.currently_selected_card = card
	#print(cards.currently_selected_card)
	enemies_node.toggle_selectability_on()
	
func raycast_check_for_character():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		if result[0].collider.get_parent().is_in_group("Character"):
			return result[0].collider.get_parent()
	return null
	
func cast_card_on_character(card: Card, character: Character) -> void:
	for action in card.card_stats.card_actions:
		#print(action.ACTION_TYPE)
		if action.type == action.ACTION_TYPE.DAMAGE:
			character.take_damage(action.value)
			#print(str(char)+' took '+str(action.value)+ ' damage')
			cards.discard_pile.discarded_cards.append(card)
			cards.currently_selected_card.reparent(cards.discard_pile)
			cards.currently_selected_card = null
			cards.discard_pile.move_cards_to_discard()
			cards.discard_pile.print_all_discarded_cards()
			enemies_node.toggle_selectability_off()
			cards.hand_area.update_cards()
	
