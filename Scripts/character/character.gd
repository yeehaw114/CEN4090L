extends Node
class_name Character

@export_category('Stats')
@export var health: int
@export var dmg: int

func begin_turn():
	pass
	
func end_turn():
	pass
	
func _process(delta: float) -> void:
	pass
	
func take_damage():
	pass
	
func heal():
	pass
	
func cast_combat_action():
	pass
