extends Panel

@onready var item_display: TextureRect = $ItemDisplay
@onready var item_popup: Panel = $ItemPopup
@onready var item_count: Label = $ItemCount

var slotData: InvSlot
var is_mouse_over := false
var popup_visible := false
var is_able_to_be_used := false

signal item_used(item: InvItem)
signal item_got(item: InvItem)

func update(slot: InvSlot):
	
	if !slot.item:
		item_display.visible = false
		item_count.hide()
	else:
		item_display.visible = true
		item_count.show()
		item_count.text = str(slot.amount)
		item_display.texture = slot.item.texture
		slotData = slot
		#print('\nslot: '+str(self))
		#print('slot_item: '+str(slot.item.name))
		#print('slot_amount '+str(slot.amount))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and is_mouse_over:
		#print('player clicked on slot: '+str(self))
		if slotData:
			if slotData.item and is_able_to_be_used:
				var mouse_position = get_global_mouse_position()
				item_popup.position = mouse_position
				item_popup.show()
				popup_visible = true
			elif slotData.item and not is_able_to_be_used:
				print('attempt to insert to inventory')
				item_got.emit(slotData.item)
				slotData.amount -= 1
				if slotData.amount < 1:
					slotData.item = null
				update(slotData)
				
	if Input.is_action_just_pressed("Cancel"):
		if popup_visible:
			popup_visible = false
			item_popup.hide()

func use_item():
	if is_able_to_be_used:
		item_used.emit(slotData.item)
		slotData.amount -= 1
		if slotData.amount < 1:
			slotData.item = null
		update(slotData)
		item_popup.hide()

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false
