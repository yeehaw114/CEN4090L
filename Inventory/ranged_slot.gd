extends Panel

@onready var ranged_texture: TextureRect = $RangedTexture

var slotData: InvSlot
var is_mouse_over := false

func update(slot: InvSlot):
	if !slot.ranged:
		ranged_texture.visible = false
	elif slot.ranged:
		ranged_texture.texture = slot.ranged.texture
		ranged_texture.show()
