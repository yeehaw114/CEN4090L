extends Node2D
@onready var enemies_node: Node = $Enemies

@export var player: Character
@export var enemy: Character
var current_character: Character
var enemies: Array = []
var currently_selected_enemy: Character

var game_over: bool = false

func _ready() -> void:
	set_enemys()
	
func next_turn():
	if game_over:
		return

func set_enemys():
	for e in enemies_node.get_children():
		enemies.append(e)
		print(e.health)

func select_character():
	var e: Character
	e = enemies[0]
	e.selected()


func _on_attack_button_pressed() -> void:
	print('attack button selected')
	select_character()


func _on_skill_button_pressed() -> void:
	pass # Replace with function body.


func _on_items_button_pressed() -> void:
	pass # Replace with function body.
