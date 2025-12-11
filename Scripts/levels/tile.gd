extends Node2D
#class_name Tile

@onready var wall_collision: CollisionShape2D = $StaticBody2D/WallCollision
@onready var detection_collision: CollisionShape2D = $Area2D/DetectionCollision
@onready var area: Area2D = $Area2D

@onready var wall_sprite: Sprite2D = $WallSprite
@onready var interactable_sprite: Sprite2D = $Interactable_sprite

var tile_resource : TileResource
var interactable
var player : PlayerExploration = null
var cleared := false
var can_react := false

signal player_entered
signal player_interacted(tile: Tile)

func _ready():
	await get_tree().process_frame
	can_react = true

#func _on_body_entered(body: Node2D) -> void:
	#if body is PlayerExploration:
		#player = body
		#player_entered.emit(self)

func set_resource(res):
	tile_resource = res.duplicate(true)
	if tile_resource.wall:
		wall_collision.disabled = false
		wall_sprite.show()
	if tile_resource.starts_cleared:
		cleared = true
	if tile_resource.exit:
		interactable_sprite.show()
	

func disable_collisions():
	area.monitoring = false
	area.monitorable = false
	detection_collision.disabled = true

func enable_collisions():
	detection_collision.disabled = false
	area.monitoring = true
	area.monitorable = true
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Interact"):
		player_interacted.emit(self)
