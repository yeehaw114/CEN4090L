extends PanelContainer

@onready var character_position_point: Control = $Character_position_point
@onready var high_light_sprite: Sprite2D = $HighLightSprite

@export_range (1,4) var rank: int
@export var character: Character = null
@export var color: Color

func _ready() -> void:
	high_light_sprite.modulate = color

func highlight(toggle: bool):
	if toggle:
		high_light_sprite.show()
	else:
		high_light_sprite.hide()
	
