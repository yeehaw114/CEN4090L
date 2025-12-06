extends Panel

@onready var item_selection_container: PanelContainer = $VBoxContainer/ItemSelectionContainer
@onready var gear_selection_container: PanelContainer = $VBoxContainer/GearSelectionContainer

func _on_items_button_pressed() -> void:
	item_selection_container.show()
	gear_selection_container.hide()

func _on_gear_button_pressed() -> void:
	item_selection_container.hide()
	gear_selection_container.show()
