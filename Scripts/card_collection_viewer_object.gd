extends Node2D

signal interacted_with

@export var sprite : Texture2D

#@onready var menu_sprite: Sprite2D = $Sprite2D
@onready var click_popup: Sprite2D = $ClickPopup

func _ready() -> void:
	#call_deferred("set_sprite")
	pass

func set_sprite(sprite):
	sprite.texture = sprite

func display_card_collection_viewer():
	interacted_with.emit()

func show_popup():
	click_popup.show()
	
func hide_popup():
	click_popup.hide()
