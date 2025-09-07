extends Node2D

@export var player: Character
@export var enemy: Character
var current_character: Character

var game_over: bool = false

func next_turn():
	if game_over:
		return
