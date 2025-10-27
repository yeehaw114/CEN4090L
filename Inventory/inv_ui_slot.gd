extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display

func update(slot: InvSlot):
	if !slot.card:
		item_visual.visible = false
	else:
		# Check if card has an image
		if slot.card.card_image:
			item_visual.visible = true
			item_visual.texture = slot.card.card_image
		else:
			# Card exists but has no image
			item_visual.visible = false
