extends Control
class_name InventoryLevel

@export var inventoryData : Inv
@export var is_player_inventory := false

@onready var inv: Inv
@onready var grid_container: GridContainer = $GridContainer
@onready var slots: Array = grid_container.get_children()
@onready var slot_scene := preload("res://Inventory/inventory_slot.tscn")

const inv_test = preload("res://Inventory/playerinventory.tres")

signal item_used(item: InvItem)
signal item_got(item: InvItem)


func _ready() -> void:
	print("Declared signals:", get_signal_list())
	print("INVENTORY LEVEL INSTANCE:", self)
	print("LIVE CONNECTIONS:")
	for c in get_signal_connection_list("item_got"):
		print("item_got →", c)
	for c in get_signal_connection_list("item_used"):
		print("item_used →", c)

	#if inventoryData:
		#inv = inventoryData.duplicate(true)
	#else:
		#inv = inv_test.duplicate(true)
	
	#inv.update.connect(update_slots)
	#spawn_slots(inv.columns,inv.slots.size())
	# Connect only once
	#inv.update.connect(update_slots)
	#spawn_slots(inv.columns,inv.slots.size())
	
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
	print("GOT ITEM CALLED!", item)
	print(item, " is InvItem? ", item is InvItem)
	item_got.emit(item)
	var level = get_tree().get_root().get_node("Level")
	print(level)
	level.attempt_to_insert_item(item)
	
