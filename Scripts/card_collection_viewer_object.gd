extends Node2D

signal interacted_with

@export var sprite : Texture2D

@onready var menu_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	call_deferred("set_sprite")

func set_sprite(sprite):
	sprite.texture = sprite

func display_card_collection_viewer():
	interacted_with.emit()
