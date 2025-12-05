extends Control

@export var inventoryData : WeaponInv

@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = grid_container.get_children()
@onready var slot_scene := preload("res://Inventory/weapon_slot.tscn")

func spawn_slots(columns: int, num_slots: int):
	slots.clear()

	# Immediately delete children
	for child in grid_container.get_children():
		child.free() # <-- NOT queue_free()

	grid_container.columns = columns

	for i in range(num_slots):
		var new_slot = slot_scene.instantiate()
		grid_container.add_child(new_slot)

	slots = grid_container.get_children()
	update_slots()

func update_slots():
	for i in range(min(inventoryData.slots.size(), slots.size())):
		slots[i].update(inventoryData.slots[i])

func add_inventory(other_inv: Inv):
	if !inventoryData or !other_inv:
		return
	for slot in other_inv.slots:
		if slot.item:
			inventoryData.insert(slot.item)
				
func set_inventory(inv: WeaponInv):
	inventoryData = inv
	reload_inventory()

func reload_inventory():
	if !inventoryData:
		return
	inventoryData.update.connect(update_slots)
	spawn_slots(inventoryData.columns, inventoryData.slots.size())
