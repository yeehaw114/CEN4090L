extends Node

var enemies: Array = []

func _ready():
	set_enemys()

func set_enemys():
	for e in get_children():
		enemies.append(e)

func toggle_selectability_on():
	print('toggle')
	for e in enemies:
		e.is_able_to_be_selected = true

func toggle_selectability_off():
	for e in enemies:
		e.is_able_to_be_selected = false
