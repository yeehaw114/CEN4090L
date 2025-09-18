extends PanelContainer

@onready var character_position_point: Control = $Character_position_point

@export_range (1,4) var rank: int
@export var character: Character = null
