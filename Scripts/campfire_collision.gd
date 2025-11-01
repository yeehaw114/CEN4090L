extends StaticBody2D

@onready var campfire: Node2D = $".."

func use():
	campfire.use()
	
func show_popup():
	campfire.show_popup()
	
func hide_popup():
	campfire.hide_popup()
