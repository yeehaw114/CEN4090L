extends StaticBody2D

@onready var chest: Node2D = $".."

func open():
	chest.open()
