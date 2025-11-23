extends Resource
class_name Inv

@export var slots: Array[InvSlot] = []
@export var columns: int = 1
@export var is_players := false

signal update

@export var max_health: int = 100
@export var current_health: int = 100
@export var coins: int = 0

func insert(item: InvItem) -> void:
	#print('item trying to insert: '+str(item.name))
	if not is_players:
		return

	for slot in slots:
		if slot.item:
			if slot.item.name == item.name:
				slot.amount += 1
				update.emit()
				return
	for slot in slots:
		if not slot.item:
			slot.item = item
			slot.amount += 1
			update.emit()
			return
	print('inventory too full!')
	update.emit()

# Creates a fresh duplicate where each slot and item is duplicated
func duplicate_fresh() -> Inv:
	var new_inv = Inv.new()
	new_inv.slots.clear()  # clear the default exported array
	for slot in slots:
		var new_slot = InvSlot.new()
		if slot.item:
			new_slot.item = slot.item.duplicate(true)
			new_slot.amount = slot.amount
		new_inv.slots.append(new_slot)
	return new_inv
