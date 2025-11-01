extends Node2D

const lit_texture = preload("res://Assets/Textures/campfire_lit.png")
const unlit_texture = preload("res://Assets/Textures/campfire_unlit.png")

@onready var sprite_2d: Sprite2D = $Sprite2D

var is_used := false

func use():
	if !is_used:
		print('campire used')
		sprite_2d.texture = unlit_texture
		GameState.heal(10)
		is_used = true
