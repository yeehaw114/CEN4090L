extends Character
class_name Enemy

@onready var select_ring: Sprite2D = $SelectRing

func selected():
	select_ring.visible = true
	
func unselected():
	select_ring.visible = false
