extends Panel

@onready var ranged_texture: TextureRect = $RangedTexture
@onready var gear_description_popup: Panel = $GearDescriptionPopup

var slotData: InvSlot
var is_mouse_over := false

func update(slot: InvSlot):
	if !slot.item:
		ranged_texture.visible = false
		slotData = null
	elif slot.item:
		ranged_texture.texture = slot.item.texture
		ranged_texture.show()
		slotData = slot
		gear_description_popup.set_values(slot.item)

func _on_mouse_entered() -> void:
	if not slotData:
		return
	if slotData.item:
		gear_description_popup.show()

func _on_mouse_exited() -> void:
	gear_description_popup.hide()
