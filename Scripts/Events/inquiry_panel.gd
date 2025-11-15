extends Panel

@onready var button_container: HBoxContainer = $ButtonContainer

func disable_all_buttons():
	for button in button_container.get_children():
		button.disabled = true
