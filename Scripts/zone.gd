extends ColorRect
class_name Zone

@export var collision_shape : CollisionShape2D
@export var type : TYPE

enum TYPE {MISS,BAD,OK,GREAT}

func set_collision_shape_size(size: Vector2):
	collision_shape.shape.size = size
