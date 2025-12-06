extends PanelContainer

@onready var weapon_slot: Panel = $GearContainer/WeaponSlot
@onready var ranged_slot: Panel = $GearContainer/RangedSlot
@onready var armour_slot: Panel = $GearContainer/ArmourSlot

@onready var weapon_inventory: Control = $PanelContainer/VBoxContainer/ScrollContainer/WeaponInventory
@onready var ranged_inventory: Control = $PanelContainer/VBoxContainer/ScrollContainer/RangedInventory
@onready var armour_inventory: Control = $PanelContainer/VBoxContainer/ScrollContainer/ArmourInventory

func _ready() -> void:
	weapon_inventory.set_inventory(weapon_inventory.inventoryData)
	ranged_inventory.set_inventory(ranged_inventory.inventoryData)
	armour_inventory.set_inventory(armour_inventory.inventoryData)
	
	var weapon_slot_data = InvSlot.new()
	var ranged_slot_data = InvSlot.new()
	var armour_slot_data = InvSlot.new()
	PlayerInventory.change_melee(weapon_slot_data.item)
	PlayerInventory.change_ranged(ranged_slot_data.item)
	PlayerInventory.change_armour(armour_slot_data.item)
	weapon_slot.update(weapon_slot_data)
	ranged_slot.update(ranged_slot_data)
	armour_slot.update(armour_slot_data)
	

func _on_melee_button_pressed() -> void:
	weapon_inventory.show()
	ranged_inventory.hide()
	armour_inventory.hide()

func _on_ranged_button_pressed() -> void:
	weapon_inventory.hide()
	ranged_inventory.show()
	armour_inventory.hide()

func _on_armour_button_pressed() -> void:
	weapon_inventory.hide()
	ranged_inventory.hide()
	armour_inventory.show()
