extends Control

@onready var weapon_slot: Panel = $ProvisionPanel/VBoxContainer/GearSelectionContainer/GearContainer/WeaponSlot
@onready var ranged_slot: Panel = $ProvisionPanel/VBoxContainer/GearSelectionContainer/GearContainer/RangedSlot
@onready var armour_slot: Panel = $ProvisionPanel/VBoxContainer/GearSelectionContainer/GearContainer/ArmourSlot


const level_select_scene := "res://Scenes/level_select.tscn"

func _on_venture_button_pressed() -> void:
	PlayerInventory.change_melee(weapon_slot.slotData.item)
	PlayerInventory.change_ranged(ranged_slot.slotData.item)
	PlayerInventory.change_armour(armour_slot.slotData.item)
	get_tree().change_scene_to_packed(LevelManager.current_scene)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file(level_select_scene)
