extends Control

@onready var enemy_stats_container: HBoxContainer = $EnemyStatsContainer
@onready var defenses_container: VBoxContainer = $DefensesContainer

func _on_battle_manager_enemy_clicked(char: Character) -> void:
	show()
	enemy_stats_container.update_health(char.health,char.max_health)
	enemy_stats_container.update_nerve(char.nerve,char.max_nerve)
	if char is not Player:
		defenses_container.set_defenses(char.enemy_resource)
