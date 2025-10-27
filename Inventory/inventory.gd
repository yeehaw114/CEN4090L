extends Resource
class_name Inv

@export var slots: Array[InvSlot] = []
@export var max_health: int = 100
@export var current_health: int = 100
@export var coins: int = 0

func insert(card: CardResource, amount: int = 1) -> void:
	# Check if card already exists (for stacking)
	for slot in slots:
		if slot.card == card:
			slot.amount += amount
			return
	
	# Otherwise, create new slot
	var new_slot := InvSlot.new()
	new_slot.card = card
	new_slot.amount = amount
	slots.append(new_slot)
