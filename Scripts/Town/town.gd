extends Control

@onready var entrances: Control = $Entrances
@onready var storage_ui: Control = $StorageUI
@onready var bar_ui: Control = $BarUI

const level_select_filepath := "res://Scenes/level_select.tscn"

var is_in_dialouge
var is_in_area := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		var selected_entrance = entrances.check_if_mouse_over_entrance()
		if selected_entrance and not is_in_area:
			if selected_entrance.area == 'storage':
				storage_ui.show()
				is_in_area = true
			elif selected_entrance.area == 'field':
				bar_ui.show()
				is_in_area = true

func _on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file(level_select_filepath)

func leave_area():
	is_in_area = false


func _on_inventory_level_item_used(item: InvItem) -> void:
	if item.stat == InvItem.STAT.HEALTH:
		PlayerInventory.heal(item.value)
	elif item.stat == InvItem.STAT.NERVE:
		PlayerInventory.heal_nerve(item.value)
