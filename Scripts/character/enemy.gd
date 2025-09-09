extends Character
class_name Enemy

@onready var select_ring: Sprite2D = $SelectRing



func selected():
	select_ring.visible = true
	
func unselected():
	select_ring.visible = false

func mouse_entered_body() -> void:
	print('mouse hovered over body')
	select_ring.visible = true
	
func mouse_exited_body() -> void:
	select_ring.visible = false
