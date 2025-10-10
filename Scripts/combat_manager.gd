extends Node2D

@onready var cards: Node2D = $"../Cards"
@onready var enemies: Node2D = $"../Enemies"
@onready var player_container: HBoxContainer = $"../../CharacterContainer/PlayerContainer"
@onready var enemy_container: HBoxContainer = $"../../CharacterContainer/EnemyContainer"
@onready var player: Player = $"../Player"

@export var max_energy := 3
var current_energy := max_energy
signal energy_changed(energy: int)

func _on_card_selected(card: Card) -> void:
	cards.currently_selected_card = card
	#print(cards.currently_selected_card)
	enemies.toggle_selectability_on()
	
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
	if card.card_stats.card_cost > current_energy:
		return
	for action in card.card_stats.card_actions:
		if action.type == action.ACTION_TYPE.DAMAGE:
			use_energy(card.card_stats.card_cost)
			energy_changed.emit(current_energy)
			enemy.take_damage(action.value)
			cards.currently_selected_card = null
			cards.discard_pile.move_card_to_discard(card)
			enemies.toggle_selectability_off()
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
	print('\nMOVING CHARACTER--------------------')
	print('moving '+str(character)+' to '+str(rank))
	print('position to move to: '+str(character.global_position))
	print('-------------------------------------\n')
	
func set_enemy_rank(character: Character, rank: int):
	var tile_to_move_to = enemy_container.get_tile(rank)
	var character_current_tile = enemy_container.get_tile_by_char(character)
	if character_current_tile:
		character_current_tile.character = null
	tile_to_move_to.character = character
	character.global_position = tile_to_move_to.character_position_point.global_position
	print('\nMOVING CHARACTER--------------------')
	print('moving '+str(character)+' to '+str(rank))
	print('position to move to: '+str(character.global_position))
	print('-------------------------------------\n')
	
func enemies_do_action(enemes: Array):
	for e in enemes:
		var enemy_action = e.current_action
		print('\nENEMY ATTEMPTING TO DO ACTION: '+str(enemy_action)+'\n')
		if enemy_action.type == Action.ACTION_TYPE.DAMAGE:
			print(str(e)+" is attempting to deal "+str(enemy_action.value)+' dmg')
			player.take_damage(enemy_action.value)
		elif enemy_action.type == Action.ACTION_TYPE.BLOCK:
			print(str(e)+" is attempting to block "+str(enemy_action.value)+' dmg')
			e.add_and_set_block_value(enemy_action.value)
			
func use_energy(cost: int):
	current_energy -= cost
	if current_energy < 0:
		current_energy = 0

func reset_energy():
	current_energy = max_energy
	energy_changed.emit(current_energy)
