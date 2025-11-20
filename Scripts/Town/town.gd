extends Control

@onready var entrances: Control = $Entrances

const level_select_filepath := "res://Scenes/level_select.tscn"

var is_in_dialouge

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		var selected_entrance = entrances.check_if_mouse_over_entrance()
		if selected_entrance:
			selected_entrance.enter_dialouge()


func _on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file(level_select_filepath)
