extends Control

@onready var entrances: Control = $Entrances

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		entrances.check_if_mouse_over_entrance()
