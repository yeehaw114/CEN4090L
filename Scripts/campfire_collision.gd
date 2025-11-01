extends StaticBody2D

@onready var campfire: Node2D = $".."

func use():
	campfire.use()
