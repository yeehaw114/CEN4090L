extends Control
class_name InventoryLevel

@export var inventoryData : Inv
@export var is_player_inventory := false
@export var is_in_level := true

@onready var inv: Inv
@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = grid_container.get_children()
@onready var slot_scene := preload("res://Inventory/inventory_slot.tscn")

const inv_test = preload("res://Inventory/playerinventory.tres")

signal item_used(item: InvItem)
signal item_got(item: InvItem)
	
func set_inventory(inv: Inv):
	inventoryData = inv
	reload_inventory()
	
func reload_inventory():
	if !inventoryData:
		return
	inv = inventoryData.duplicate(true)
	inv.update.connect(update_slots)
	spawn_slots(inv.columns, inv.slots.size())

func spawn_slots(columns: int, num_slots: int):
	slots.clear()

	# Immediately delete children
	for child in grid_container.get_children():
		child.free() # <-- NOT queue_free()

	grid_container.columns = columns

	for i in range(num_slots):
		var new_slot = slot_scene.instantiate()
		grid_container.add_child(new_slot)
		
		new_slot.item_used.connect(used_item)
		new_slot.item_got.connect(got_item)
			
		if is_player_inventory:
			new_slot.is_able_to_be_used = true

	slots = grid_container.get_children()
	update_slots()

func update_slots():
	print('\nINV TO BE UPDATED: '+str(inv))
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func used_item(item: InvItem):
	item_used.emit(item)
	
func got_item(item: InvItem):
	if not is_in_level:
		item_got.emit(item)
		return
	print("GOT ITEM CALLED!", item)
	print(item, " is InvItem? ", item is InvItem)
	item_got.emit(item)
	var level = get_tree().get_root().get_node("Level3D")
	print(level)
	level.attempt_to_insert_item(item)
	
func add_inventory(other_inv: Inv):
	if !inventoryData or !other_inv:
		return
	for slot in other_inv.slots:
		if slot.item and slot.amount > 0:
			for i in range(slot.amount):
				inventoryData.insert(slot.item)
