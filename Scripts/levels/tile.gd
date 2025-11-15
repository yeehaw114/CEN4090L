extends Node2D
class_name Tile

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var wall_sprite: Sprite2D = $WallSprite

var tile_resource : TileResource
var interactable
var player : PlayerExploration = null
var cleared := false

signal player_entered

func _on_body_entered(body: Node2D) -> void:
	player_entered.emit(self)

func set_resource(res):
	tile_resource = res.duplicate(true)
	if tile_resource.wall:
		collision_shape_2d.disabled = false
		wall_sprite.show()
