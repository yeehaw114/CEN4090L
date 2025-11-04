extends Node2D

@export var coins := 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coins_popup_position: Marker2D = $CoinsPopupPosition
@onready var chest_open_sound: AudioStreamPlayer2D = $ChestOpenSound

const closed_region = Rect2(0,32,16,16)
const open_region = Rect2(0,0,16,32)

var chest_opened := false

func open():
	if chest_opened:
		return
	chest_opened = true
	GameState.coins_current += coins
	coins_popup_position.popup(coins)
	chest_open_sound.play()
	print('COINS NEW VALUE: '+str(GameState.coins_current))
	sprite_2d.region_rect = open_region
	sprite_2d.offset = Vector2(0,-16)
