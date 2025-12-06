extends Line2D

@onready var point: Sprite2D = $Point
@onready var red_hit_range: Sprite2D = $RedHitRange
@onready var orange_hit_range: Sprite2D = $OrangeHitRange

@onready var zone_area: Area2D = $RedHitRange/ZoneArea

@onready var zone_collision_shape: CollisionShape2D = $HitRange/ZoneArea/ZoneCollisionShape

var start_point: Vector2
var end_point: Vector2
var t: float = 0.0
var speed: float = 1.0
var direction: int = 1

func _ready() -> void:
	start_point = points[0]
	end_point = points[1]

func _process(delta: float) -> void:
	move_point(delta)
	if zone_area.get_overlapping_bodies().size() > 0:
		print("Overlapping with:", zone_area.get_overlapping_bodies())

func move_point(delta: float):
	t += direction * speed * delta

	if t >= 1.0:
		t = 1.0
		direction = -1
	elif t <= 0.0:
		t = 0.0
		direction = 1

	var eased_t = t * t * (3.0 - 2.0 * t)
	var pos = start_point.lerp(end_point, eased_t)
	point.position = pos

func get_midpoint():
	var midpoint = start_point + end_point
	midpoint.x / 2.0
	midpoint.y / 2.0
	return midpoint

func set_hit_range(percentage_of_line: float):
	red_hit_range.scale.x = percentage_of_line
	orange_hit_range.scale.x = 2
