extends Control

@onready var entrances: Control = $Entrances

var is_in_dialouge

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		var selected_entrance = entrances.check_if_mouse_over_entrance()
		if selected_entrance:
			selected_entrance.enter_dialouge()


func _on_level_select_button_pressed() -> void:
	pass # Replace with function body.
