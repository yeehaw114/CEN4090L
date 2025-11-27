extends Node
class_name Character

@export_category('Stats')
@export var health: int
@export var max_health:int = 20
var max_nerve: int = 100
var nerve = max_nerve
@export var sprite: Texture2D

var damage_modifier := 0
var damage_increase := 0
var damage_decrease := 0

var block_modifier := 0
var block_increase := 0
var block_decrease := 0

var is_able_to_be_selected = false
var is_dead = false
var rank : int = -1
var block_value := 0 

var status_effects : Array[StatusEffect]

signal took_damage(damage: int)
signal healh_changed(health: int)

func begin_turn():
	pass
	
func end_turn():
	pass
	
func _process(delta: float) -> void:
	pass
	
func take_damage(damage: int):
	health -= damage
	
func heal():
	pass
	
func cast_combat_action():
	pass
