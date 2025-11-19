extends Area2D

@export var intro : String

var is_mouse_over := false

signal dialouge_entered

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false

func enter_dialouge():
	Dialogic.start(intro)
	dialouge_entered.emit()
