extends Node2D
class_name Tile

@onready var wall_collision: CollisionShape2D = $StaticBody2D/WallCollision
@onready var detection_collision: CollisionShape2D = $Area2D/DetectionCollision
@onready var area: Area2D = $Area2D

@onready var wall_sprite: Sprite2D = $WallSprite

var tile_resource : TileResource
var interactable
var player : PlayerExploration = null
var cleared := false
var can_react := false

signal player_entered

func _ready():
	await get_tree().process_frame
	can_react = true

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerExploration:
		player = body
		player_entered.emit(self)

func set_resource(res):
	tile_resource = res.duplicate(true)
	if tile_resource.wall:
		wall_collision.disabled = false
		wall_sprite.show()
	if tile_resource.starts_cleared:
		cleared = true

func disable_collisions():
	area.monitoring = false
	area.monitorable = false
	detection_collision.disabled = true

func enable_collisions():
	detection_collision.disabled = false
	area.monitoring = true
	area.monitorable = true
	
