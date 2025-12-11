extends Node3D
class_name Tile

@onready var wall_collision: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var detection_collision: CollisionShape3D = $Area/CollisionShape3D

@onready var area: Area3D = $Area
@onready var midpoint: Marker3D = $Midpoint
@onready var backwall: CSGBox3D = $Backwall

@onready var wall_block: CSGBox3D = $WallBlock
#@onready var interactable_sprite: Sprite2D = $Interactable_sprite

var tile_resource : TileResource
var interactable
var player : PlayerExploration = null
var cleared := false
var can_react := false

signal player_entered
signal player_interacted(tile: Tile)

func _ready():
	can_react = true
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerExploration:
		player = body
		player_entered.emit(self)

func set_resource(res):
	tile_resource = res.duplicate(true)
	if tile_resource.wall:
		wall_collision.disabled = false
		wall_block.show()
		wall_block.use_collision = true
	if tile_resource.starts_cleared:
		cleared = true
	if tile_resource.exit:
		backwall.hide()
	
func disable_collisions():
	area.monitoring = false
	area.monitorable = false
	detection_collision.disabled = true

func enable_collisions():
	detection_collision.disabled = false
	area.monitoring = true
	area.monitorable = true
	
func _on_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("Interact"):
		player_interacted.emit(self)
