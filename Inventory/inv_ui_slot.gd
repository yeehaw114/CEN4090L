extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var card_scene: PackedScene = preload("res://Scenes/card.tscn")
@onready var panel_container: PanelContainer = $NinePatchRect/MarginContainer/PanelContainer
@onready var card_test: CardResource = preload("res://Assets/Resources/cards/final_cards/defend_card.tres")

func _ready():
	add_card_to_inventory(card_test)

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
			
func add_card_to_inventory(card_stat: CardResource) -> void:
	var new_card = card_scene.instantiate()
	new_card.card_stats = card_stat
	new_card.call_deferred("set_values")
	new_card.is_able_to_be_selected = false
	panel_container.add_child(new_card)
