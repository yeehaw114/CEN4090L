extends Panel

@onready var gear_texture: TextureRect = $GearTexture
@onready var gear_description_popup: PanelContainer = $GearDescriptionPopup

var slotData: InvSlot
var is_mouse_over := false

signal slot_clicked_on(slot: InvSlot)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and is_mouse_over:
		if slotData and slotData.item:
			slot_clicked_on.emit(slotData)

func update(slot: InvSlot):
	if !slot.item:
		gear_texture.visible = false
		slotData = null
	elif slot.item:
		gear_texture.texture = slot.item.texture
		gear_texture.show()
		slotData = slot
		gear_description_popup.set_values(slot.item)

func _on_mouse_entered() -> void:
	is_mouse_over = true
	if not slotData:
		return
	if slotData.item:
		gear_description_popup.show()

func _on_mouse_exited() -> void:
	is_mouse_over = false
	gear_description_popup.hide()


func _on_weapon_inventory_external_slot_clicked(slot: InvSlot) -> void:
	update(slot)
