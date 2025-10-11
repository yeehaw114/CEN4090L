extends Node2D

@onready var player: Player = $Player
@onready var combat_manager: Node2D = $CombatManager

@onready var battle_resource := preload("res://Assets/Resources/battles/deer_2.tres")

var currently_selected_enemy: Character
var game_over := false
var can_move := true
var num_cards_drawn := 5

enum battle_state_player {MOVE=0,SELECT_CARD=1}
enum move_crystal_state {SELECT,EMPTY,NORMAL}
var active_state := -1
signal state_changed(state: int)

enum battle_state {PLAYER_STATUS,PLAYER, ENEMY_STATUS,ENEMY}
var active_battle_state := -1

var total_energy := 3
var current_eneergy := 3

func _ready() -> void:
	set_state(battle_state_player.SELECT_CARD)
	set_active_battle_state(battle_state.PLAYER)
	
	combat_manager.cards.draw_pile.draw_cards = battle_resource.starting_cards
	combat_manager.cards.draw_pile.shuffle_draw_cards()
	
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
	
	#for e in combat_manager.enemies.get_all_enemies():
		#e.set_current_action(0)
		#e.update_intention()
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

func handle_current_turn():
	if get_active_battle_state() == battle_state.PLAYER_STATUS:
		#APPLY STATUS EFFECTS TO PLAYER
		print('handling status effects on player')
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
