extends Control

@export var status_effect_resource : StatusEffect

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func set_data():
	if status_effect_resource:
		texture_rect.texture = status_effect_resource.texture
		label.text = str(status_effect_resource.count)
