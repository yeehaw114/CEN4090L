extends Node2D
@onready var enemies_node: Node = $Enemies
@onready var cards: Node = $UI/Cards

@export var player: Character
@export var enemy: Character
var current_character: Character
var enemies: Array = []
var currently_selected_enemy: Character
var currently_selected_card: Card = null

var game_over: bool = false

func _ready() -> void:
	set_enemys()
	
func next_turn():
	if game_over:
		return

func set_enemys():
	for e in enemies_node.get_children():
		enemies.append(e)
		print(str(e) + ' ' + str(e.health))

func select_character():
	var e: Character
	e = enemies[0]
	e.selected()

func _on_card_selected(card: Card) -> void:
	currently_selected_card = card
	print(currently_selected_card.card_name)
