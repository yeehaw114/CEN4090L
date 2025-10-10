extends Node

var enemies: Array = []
var enemy_scene := preload("res://Scenes/enemy.tscn")

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

func spawn_enemy(enemyResource : EnemyResource) -> Enemy:
	var new_enemy := enemy_scene.instantiate()
	new_enemy.enemy_resource = enemyResource
	add_child(new_enemy)
	enemies.append(new_enemy)
	print('SPAWING ENEMY: '+str(new_enemy.enemy_resource))
	return new_enemy
