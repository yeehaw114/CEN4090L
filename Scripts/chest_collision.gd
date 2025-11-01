extends StaticBody2D

@onready var chest: Node2D = $".."

func open():
	chest.open()

func show_popup():
	chest.show_popup()
	
func hide_popup():
	chest.hide_popup()
