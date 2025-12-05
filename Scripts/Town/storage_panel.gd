extends Panel

@onready var inventory_level: InventoryLevel = $VBoxContainer/Panel/InventoryLevel
@onready var weapon_inventory: Control = $VBoxContainer/Panel/WeaponInventory
@onready var armour_inventory: Control = $VBoxContainer/Panel/ArmourInventory
@onready var ranged_inventory: Control = $VBoxContainer/Panel/RangedInventory

func _ready() -> void:
	var item_inv = inventory_level.inventoryData
	var weapon_inv = weapon_inventory.inventoryData
	var armour_inv = armour_inventory.inventoryData
	var ranged_inv = ranged_inventory.inventoryData
	
	inventory_level.add_inventory(GameState.transferred_inv)
	GameState.transferred_inv = null
	inventory_level.set_inventory(inventory_level.inventoryData)
	
	weapon_inventory.add_inventory(GameState.transffered_reward_inv)
	GameState.transffered_reward_inv = null
	weapon_inventory.set_inventory(weapon_inv)
	
	#weapon_inventory.spawn_slots(weapon_inv.columns,weapon_inv.slots.size())
	armour_inventory.spawn_slots(armour_inv.columns,armour_inv.slots.size())
	ranged_inventory.spawn_slots(ranged_inv.columns,ranged_inv.slots.size())

func _on_items_button_pressed() -> void:
	inventory_level.show()
	weapon_inventory.hide()
	armour_inventory.hide()
	ranged_inventory.hide()

func _on_weapons_button_pressed() -> void:
	inventory_level.hide()
	weapon_inventory.show()
	armour_inventory.hide()
	ranged_inventory.hide()

func _on_armour_button_pressed() -> void:
	inventory_level.hide()
	weapon_inventory.hide()
	armour_inventory.show()
	ranged_inventory.hide()

func _on_ranged_button_pressed() -> void:
	inventory_level.hide()
	weapon_inventory.hide()
	armour_inventory.hide()
	ranged_inventory.show()
