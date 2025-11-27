extends Panel

@onready var weapon_texture: TextureRect = $WeaponTexture


var slotData: InvSlot
var is_mouse_over := false

func update(slot: InvSlot):
	if !slot.weapon:
		weapon_texture.visible = false
	elif slot.weapon:
		weapon_texture.texture = slot.weapon.texture
		weapon_texture.show()
