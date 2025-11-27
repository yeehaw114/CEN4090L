extends Control
@onready var player_stats_container: HBoxContainer = $PlayerStatsContainer
@onready var defenses_container: VBoxContainer = $DefensesContainer

func _ready() -> void:
	var armour = PlayerInventory.armour_resource
	defenses_container.set_defenses(armour)
