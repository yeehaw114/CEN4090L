extends Node
class_name Character

@export_category('Stats')
@export var health: int
@export var max_health:int = 20
@export var sprite: Texture2D

var status_effects : Array[StatusEffect]

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
