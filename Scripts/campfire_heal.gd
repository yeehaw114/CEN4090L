extends Node2D

const lit_texture = preload("res://Assets/Textures/campfire_lit.png")
const unlit_texture = preload("res://Assets/Textures/campfire_unlit.png")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var click_popup: Sprite2D = $ClickPopup

var is_used := false

func use():
	if !is_used:
		print('campire used')
		sprite_2d.texture = unlit_texture
		GameState.heal(10)
		is_used = true
		hide_popup()

func show_popup():
	if !is_used:
		click_popup.show()
	
func hide_popup():
	click_popup.hide()
