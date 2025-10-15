extends Control

@onready var move_crystal_button: TextureButton = $MoveCrystalButton
@onready var energy_label: Label = $EnergyOrb/EnergyLabel
@onready var energy_orb: TextureRect = $EnergyOrb

@onready var background: TextureRect = $Background
@onready var end_turn_button: TextureButton = $EndTurnButton
@onready var character_container: HBoxContainer = $CharacterContainer

@onready var battle_manager: Node2D = $BattleManager
@onready var hand_area: ColorRect = $BattleManager/Cards/HandArea
@onready var draw_pile: Node2D = $BattleManager/Cards/DrawPile
@onready var discard_pile: Node2D = $BattleManager/Cards/DiscardPile

@onready var display_discard_deck: Control = $DisplayDiscardDeck
@onready var display_draw_deck: Control = $DisplayDrawDeck

@onready var game_over_screen: Control = $GameOverScreen
@onready var victory_screen: Control = $VictoryScreen
@onready var pause_screen: Control = $PauseScreen

var move_crystal_normal = Rect2(Vector2(0,0),Vector2(32,32))
var move_crystal_selected = Rect2(Vector2(32,0),Vector2(32,32))
var move_crystal_empty = Rect2(Vector2(64,0),Vector2(64,32))

func _ready() -> void:
	change_move_crystal_texture(move_crystal_normal)
	set_energy_max(3)
	set_energy_value(3)
	pause_screen.un_pause_button.button_up.connect(display_pause_screen.bind(false))

func switch_to_display_discard_pile() -> void:
	move_crystal_button.visible = false
	end_turn_button.visible = false
	
	hand_area.visible = false
	draw_pile.visible = false
	discard_pile.visible = false
	
	display_draw_deck.visible = false
	energy_orb.visible = false
	battle_manager.visible = false
	
	display_discard_deck.populate_grid()
	display_discard_deck.visible = true
	
func switch_to_display_battle_screen() -> void:
	move_crystal_button.visible = true
	background.visible = true
	end_turn_button.visible = true
	character_container.visible = true
	battle_manager.visible = true
	display_discard_deck.visible = false
	display_draw_deck.visible = false
	energy_orb.visible = true
	hand_area.visible = true
	draw_pile.visible = true
	discard_pile.visible = true

func switch_to_display_draw_pile() -> void:
	move_crystal_button.visible = false
	end_turn_button.visible = false
	hand_area.visible = false
	draw_pile.visible = false
	discard_pile.visible = false
	display_draw_deck.visible = false
	energy_orb.visible = false
	battle_manager.visible = false
	
	display_draw_deck.populate_grid()
	display_draw_deck.visible = true

func set_energy_max(max: int):
	var text = energy_label.text.split('/')
	energy_label.text = text[0]+'/'+str(max)

func set_energy_value(energy: int):
	var text = energy_label.text.split('/')
	energy_label.text = str(energy)+'/'+text[1]

func _on_movement_button_pressed() -> void:
	print('movement button pressed')

func change_move_crystal_texture(texture_region: Rect2) -> void:
	if move_crystal_button:
		move_crystal_button.texture_normal.region = texture_region
	else:
		return

func _on_battle_manager_state_changed(state: int) -> void:
	#move state
	if state == 0:
		change_move_crystal_texture(move_crystal_selected)
	elif state == 1:
		change_move_crystal_texture(move_crystal_empty)
	else:
		change_move_crystal_texture(move_crystal_normal)

func on_discard_button_pressed() -> void:
	switch_to_display_discard_pile()
	
func on_draw_button_pressed() -> void:
	switch_to_display_draw_pile()

func display_game_over_screen():
	#get_tree().paused = true;
	battle_manager.combat_manager.cards.make_cards_in_hand_unselectable()
	game_over_screen.show()
	
func display_victory_screen():
	#get_tree().paused = true;
	battle_manager.combat_manager.cards.make_cards_in_hand_unselectable()
	victory_screen.show()
	
func display_pause_screen(switch: bool):
	#get_tree().paused = true;
	if switch:
		battle_manager.combat_manager.cards.make_cards_in_hand_unselectable()
		pause_screen.show()
		print('SHOW PAUSE SCREEN')
	else:
		battle_manager.combat_manager.cards.make_cards_in_hand_selectable()
		battle_manager.game_paused = false
		pause_screen.hide()
		print('HIDE PAUSE SCREEN')
