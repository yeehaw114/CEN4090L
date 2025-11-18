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
			pass
			#print(slot.item.name)
		#print('empty slot')
	#print('\n')
	
	for slot in slots:
		if slot.item:
			if slot.item.name == item.name:
				slot.amount += 1
				#print('\nincreasing by 1: '+str(slot.item.name))
	update.emit()
