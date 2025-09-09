extends Node2D
@onready var enemies_node: Node = $Enemies
@onready var cards: Node = $UI/Cards

@export var player: Character
@export var enemy: Character
var current_character: Character
var currently_selected_enemy: Character
var currently_selected_card: Card = null

var game_over: bool = false

func _ready() -> void:
	pass
	
func next_turn():
	if game_over:
		return

func select_character():
	var e: Character

func _on_card_selected(card: Card) -> void:
	currently_selected_card = card
	print(currently_selected_card.card_name)
	enemies_node.toggle_selectability_on()
