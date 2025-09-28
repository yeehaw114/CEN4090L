extends Node2D
@onready var enemies_node: Node2D = $Enemies
@onready var cards: Node2D = $Cards
@onready var player: Player = $Player
@onready var player_container: HBoxContainer = $"../CharacterContainer/PlayerContainer"
@onready var enemy_container: HBoxContainer = $"../CharacterContainer/EnemyContainer"
#@onready var player_movement_positions: Node2D = $Player_movement_positions

@export var enemy: Character

var currently_selected_enemy: Character
var game_over := false

enum battle_state_player {MOVE=0,SELECT_CARD=1}
var active_state := -1
signal state_changed(state: int)

enum battle_state {PLAYER_STATUS,PLAYER, ENEMY_STATUS,ENEMY}
var active_battle_state := -1

func _ready() -> void:
	set_state(battle_state_player.SELECT_CARD)
	set_active_battle_state(battle_state.PLAYER)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			handle_left_input()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			handle_right_input()

#FUNCTIONS FOR MANAGING BATTLE_STATE----------------------------------------------------
func next_turn():
	if game_over:
		return
	var current_state = get_active_battle_state()
	if current_state == battle_state.ENEMY:
		set_active_battle_state(0)
		return
	set_active_battle_state(current_state+1)
	
func set_active_battle_state(index: int):
	active_battle_state = index
	
func get_active_battle_state():
	for state in battle_state.values():
		if state == active_battle_state:
			return state

#--------------------------------------------------------------------------------------

func handle_left_input():
	if active_state == battle_state_player.SELECT_CARD:
		cards.attempt_to_select_card()
		var tile = raycast_check_for_tile()
		var char : Character
		if tile:
			char = tile.character
		if char != null and cards.currently_selected_card != null:
			currently_selected_enemy = char
			cast_card_on_character(player,cards.currently_selected_card,currently_selected_enemy)
	elif active_state == battle_state_player.MOVE:
		var tile = raycast_check_for_tile()
		if tile != null:
			set_player_rank(player,tile.rank)

func handle_right_input():
	if active_state == battle_state_player.SELECT_CARD:
		if cards.currently_selected_card:
			cards.unselect_card()
	elif active_state == battle_state_player.MOVE:
		set_state(battle_state_player.SELECT_CARD)



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

func raycast_check_for_tile():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		if result[0].collider.get_parent().is_in_group("Tile"):
			#print('Tile: '+str(result[0].collider.get_parent()))
			#print('Char: '+str(result[0].collider.get_parent().character))
			return result[0].collider.get_parent()
	return null
	
func cast_card_on_character(character: Character, card: Card, enemy: Character) -> void:
	if !check_character_on_valid_tile(character,card) or !check_enemy_on_valid_tile(enemy,card):
		return

	for action in card.card_stats.card_actions:
		if action.type == action.ACTION_TYPE.DAMAGE:
			enemy.take_damage(action.value)
			#print(str(char)+' took '+str(action.value)+ ' damage')
			cards.discard_pile.discarded_cards.append(card)
			cards.currently_selected_card.reparent(cards.discard_pile)
			cards.currently_selected_card = null
			cards.discard_pile.move_card_to_discard(card)
			enemies_node.toggle_selectability_off()
			cards.hand_area.update_cards()

func check_character_on_valid_tile(character: Character, card: Card) -> bool:
		var tile = player_container.get_tile_by_char(character)
		var character_rank = player_container.get_tile_by_char(character).rank
		for rank in card.card_stats.character_position:
			if rank == character_rank:
				return true
		return false

func check_enemy_on_valid_tile(character: Character, card: Card) -> bool:
		var enemy_rank = enemy_container.get_tile_by_char(character).rank
		for rank in card.card_stats.enemy_position:
			if rank == enemy_rank:
				return true
		return false

func set_player_rank(character: Character, rank: int):
	var tile_to_move_to = player_container.get_tile(rank)
	var character_current_tile = player_container.get_tile_by_char(character)
	character_current_tile.character = null
	tile_to_move_to.character = character
	character.global_position = tile_to_move_to.character_position_point.global_position
	
func set_state(index: int):
	var count := 0
	if index >= 0 and index <= 1:
		active_state = index
		state_changed.emit(index)
	else:
		print('setting incorrect state')
		
func get_current_state():
	for state in battle_state_player.values():
		if state == active_state:
			#print(state)
			return state

func _on_movement_button_pressed() -> void:
	if active_state == battle_state_player.SELECT_CARD:
		cards.unselect_card()
		set_state(battle_state_player.MOVE)
