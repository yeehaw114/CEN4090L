extends Node2D

@onready var player: Player = $Player
@onready var combat_manager: Node2D = $CombatManager

@onready var battle_resource : BattleResource
const battle_resource_test := preload("res://Assets/Resources/battles/deer_2.tres")

var currently_selected_enemy: Character
var game_over := false
var can_move := true
var game_paused := false
var num_cards_drawn := 5

enum battle_state_player {MOVE=0,SELECT_CARD=1}
enum move_crystal_state {SELECT,EMPTY,NORMAL}
var active_state := -1
signal state_changed(state: int)
signal pause_game(switch: bool)
signal rewards_decided(coins: int, cards: Array[CardResource])

enum battle_state {PLAYER_STATUS,PLAYER, ENEMY_STATUS,ENEMY}
var active_battle_state := -1

var total_energy := 3
var current_eneergy := 3

func _ready() -> void:
	if GameState.pending_battle_resource:
		battle_resource = GameState.pending_battle_resource
	else:
		battle_resource = battle_resource_test
	
	set_state(battle_state_player.SELECT_CARD)
	set_active_battle_state(battle_state.PLAYER)
	
	call_deferred('decide_rewards')
	
	combat_manager.cards.draw_pile.draw_cards = battle_resource.starting_cards
	combat_manager.cards.draw_pile.shuffle_draw_cards()
	combat_manager.cards.draw_pile.update_display_card_deck.emit(combat_manager.cards.draw_pile.draw_cards)
	
	combat_manager.call_deferred("set_player_rank", player, battle_resource.player_position)
	
	if battle_resource.enemy_rank_1:
		var enemy = combat_manager.enemies.spawn_enemy(battle_resource.enemy_rank_1)
		combat_manager.call_deferred("set_enemy_rank", enemy, 1)
		print('SPAWNING ENEMY IN RANK 1: '+str(enemy))
	if battle_resource.enemy_rank_2:
		var enemy = combat_manager.enemies.spawn_enemy(battle_resource.enemy_rank_2)
		combat_manager.call_deferred("set_enemy_rank", enemy, 2)
		print('SPAWNING ENEMY IN RANK 2: '+str(enemy))
	if battle_resource.enemy_rank_3:
		var enemy = combat_manager.enemies.spawn_enemy(battle_resource.enemy_rank_3)
		combat_manager.call_deferred("set_enemy_rank", enemy, 3)
		print('SPAWNING ENEMY IN RANK 3: '+str(enemy))
	if battle_resource.enemy_rank_4:
		var enemy = combat_manager.enemies.spawn_enemy(battle_resource.enemy_rank_4)
		combat_manager.call_deferred("set_enemy_rank", enemy, 4)
		print('SPAWNING ENEMY IN RANK 4: '+str(enemy))
	combat_manager.cards.draw_cards(5)
	
func _input(event: InputEvent) -> void:
	if get_active_battle_state() != battle_state.PLAYER:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			handle_left_input()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			handle_right_input()
	elif Input.is_action_just_released('Pause'):
		if game_paused:
			game_paused = false
			pause_game.emit(game_paused)
		else:
			game_paused = true
			if combat_manager.cards.currently_selected_card:
				combat_manager.cards.unselect_card()
			pause_game.emit(game_paused)

func handle_current_turn():
	if game_over:
		return
	if get_active_battle_state() == battle_state.PLAYER_STATUS:
		#APPLY STATUS EFFECTS TO PLAYER
		print('handling status effects on player')
		player.aply_status_effects()
		next_turn()
	elif get_active_battle_state() == battle_state.PLAYER:
		#ALLOW PLAYER TO PLAY CARDS, LOOK AT THEIR CARDS, AND MOVE
		print('handling player turn')
		player.clear_block_value()
		combat_manager.cards.draw_cards(5)
		combat_manager.reset_energy()
		can_move = true
		state_changed.emit(move_crystal_state.NORMAL)
		for e in combat_manager.enemies.get_all_enemies():
			e.next_action()
			e.update_intention()
	elif get_active_battle_state() == battle_state.ENEMY_STATUS:
		#APPLY STATUS EFFECTS TO ENEMYS
		print('handling status effects on enemies')
		combat_manager.enemies.apply_status_effect_to_all_enemies()
		next_turn()
	elif get_active_battle_state() == battle_state.ENEMY:
		#ALLOW ENEMIES TO DO THEIR ACTIONS
		print('handling enemies turn')
		var enemies = combat_manager.enemies.get_all_enemies()
		print('\nCURRENT ENEMIES: '+str(enemies)+'\n')
		for e in enemies:
			e.clear_block_value()
		combat_manager.enemies_do_action(enemies)
		next_turn()
	
#FUNCTIONS FOR MANAGING BATTLE_STATE----------------------------------------------------
func next_turn():
	if game_over:
		return
	var current_state = get_active_battle_state()
	if current_state == battle_state.ENEMY:
		set_active_battle_state(0)
		handle_current_turn()
		return
	set_active_battle_state(current_state+1)
	handle_current_turn()
	
func set_active_battle_state(index: int):
	active_battle_state = index
	
func get_active_battle_state():
	for state in battle_state.values():
		if state == active_battle_state:
			return state

#HANDLE LEFT AND RIGHT INPUT-----------------------------------------------------------
func handle_left_input():
	if active_state == battle_state_player.SELECT_CARD:
		combat_manager.cards.attempt_to_select_card()
		var tile = combat_manager.raycast_check_for_tile()
		var char : Character
		if tile:
			char = tile.character
		if char != null and combat_manager.cards.currently_selected_card != null:
			currently_selected_enemy = char
			if currently_selected_enemy.is_in_group('Player'):
				combat_manager.cast_card_on_player(player, combat_manager.cards.currently_selected_card)
			else:
				combat_manager.cast_card_on_character(player,combat_manager.cards.currently_selected_card,currently_selected_enemy)
	elif active_state == battle_state_player.MOVE:
		var tile = combat_manager.raycast_check_for_tile()
		if tile != null:
			combat_manager.set_player_rank(player,tile.rank)
			can_move = false
			state_changed.emit(1)
			set_state(battle_state_player.SELECT_CARD)

func handle_right_input():
	if active_state == battle_state_player.SELECT_CARD:
		if combat_manager.cards.currently_selected_card:
			combat_manager.cards.unselect_card()
	elif active_state == battle_state_player.MOVE:
		if can_move:
			state_changed.emit(move_crystal_state.NORMAL)
		else:
			state_changed.emit(move_crystal_state.EMPTY)
		set_state(battle_state_player.SELECT_CARD)
#--------------------------------------------------------------------------------------

func set_state(index: int):
	var count := 0
	if index >= 0 and index <= 1:
		active_state = index
		#state_changed.emit(index)
		#can_move = false
	else:
		print('setting incorrect state')
		
func get_current_state():
	for state in battle_state_player.values():
		if state == active_state:
			#print(state)
			return state
	
func decide_rewards():
	var coins := randi_range(battle_resource.coins_min,battle_resource.coins_max)
	var cards = battle_resource.cards.duplicate() # make a copy to avoid mutating the original
	var final_cards: Array[CardResource] = []

	# Make sure there are at least 3 cards to choose from
	if cards.size() < 3:
		push_warning("Not enough cards in battle_resource.cards to select 3 unique rewards.")
		final_cards = cards.duplicate() # take all if less than 3
	else:
		while final_cards.size() < 3:
			var index = randi_range(0, cards.size() - 1)
			final_cards.append(cards[index])
			cards.remove_at(index)
	rewards_decided.emit(coins,final_cards)
	
func _on_movement_button_pressed() -> void:
	if !can_move:
		return
	if active_state == battle_state_player.SELECT_CARD:
		combat_manager.cards.unselect_card()
		set_state(battle_state_player.MOVE)
		state_changed.emit(move_crystal_state.SELECT)

func _on_end_turn_button_pressed() -> void:
	if active_battle_state == battle_state.PLAYER:
		print('end turn')
		combat_manager.cards.discard_all_cards()
		next_turn()

func _on_enemies_all_enemies_died() -> void:
	game_over = true

func _on_player_player_died() -> void:
	game_over = true
