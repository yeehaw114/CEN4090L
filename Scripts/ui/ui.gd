extends Control

var display_card_deck = preload("res://Scenes/display_card_deck.tscn")

@onready var move_crystal_button: TextureButton = $MoveCrystalButton
@onready var discard_pile: Node2D = $BattleManager/Cards/DiscardPile

var move_crystal_normal = Rect2(Vector2(0,0),Vector2(32,32))
var move_crystal_selected = Rect2(Vector2(32,0),Vector2(32,32))
var move_crystal_empty = Rect2(Vector2(64,0),Vector2(64,32))

func _ready() -> void:
	change_move_crystal_texture(move_crystal_normal)


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
	else:
		change_move_crystal_texture(move_crystal_normal)


func on_discard_button_pressed() -> void:
	var discarded_cards = discard_pile.get_discarded_cards()
	var discarded_cards_stats = []
	for card in discarded_cards:
		discarded_cards_stats.append(card.card_stats)
	
	#FIX THIS CHANGE_SCENE_TO_FILE FREES GAMESTATE.BATTLE_SCENE FROM MEMORY
	GameState.transferred_cards = discarded_cards_stats
	GameState.battle_scene = get_tree().current_scene
	get_tree().change_scene_to_file("res://Scenes/display_card_deck.tscn")
