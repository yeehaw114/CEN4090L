extends Marker2D

@onready var label: Label = $Label

func set_damage(damage: int):
	label.text = str(damage)
