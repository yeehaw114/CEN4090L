extends Node

var enemies: Array = []

func _ready():
	set_enemys()

func set_enemys():
	for e in get_children():
		enemies.append(e)

func toggle_selectability_on():
	for e in enemies:
		e.turn_selectibility_on()

func toggle_selectability_off():
	for e in enemies:
		e.turn_selectibility_off()

func get_all_enemies() -> Array:
	return enemies

func spawn_enemies():
	pass
