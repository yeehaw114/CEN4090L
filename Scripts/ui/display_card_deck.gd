extends Control

@export var card_scene: PackedScene = preload("res://Scenes/card.tscn")
@export var grid_width: int = 7
@export var grid_height: int = 7
@export var cell_size: Vector2 = Vector2(36, 48)

@onready var grid_container: GridContainer = $VBoxContainer/MarginContainer/GridContainer

var cards: Array[Card]
var stats_list : Array[CardResource]

func _ready():
	var stats_list = GameState.transferred_cards
	GameState.clear()
	
	for stats in stats_list:
		var card = card_scene.instantiate()
		card.card_stats = stats  # reattach resource to new Card node
		add_child(card)
		cards.append(card)
	print(cards)
func populate_grid():
	pass


func _on_exit_button_pressed() -> void:
	var old_scene = get_tree().current_scene
	# Reparent the battle scene to root BEFORE freeing old_scene
	if GameState.battle_scene.get_parent() != get_tree().root:
		get_tree().root.add_child(GameState.battle_scene)
	
	print(GameState.battle_scene)
	
	get_tree().current_scene = GameState.battle_scene
