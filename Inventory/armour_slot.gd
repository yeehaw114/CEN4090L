extends Panel

@onready var armour_texture: TextureRect = $ArmourTexture

var slotData: InvSlot
var is_mouse_over := false

func update(slot: InvSlot):
	if !slot.armour:
		armour_texture.visible = false
	elif slot.armour:
		armour_texture.texture = slot.armour.texture
		armour_texture.show()
