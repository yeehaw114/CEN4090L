extends CharacterBody2D
#class_name PlayerExploration

@onready var camera_2d: Camera2D = $Camera2D

const SPEED = 150
const ACCELERATION = 10.0

var input: Vector2
var can_move := true

func get_input() -> Vector2:
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = 0
	return input.normalized()

func _init() -> void:
	pass
	
func _process(delta: float) -> void:
	var playerInput = get_input()
	if can_move:
		velocity = lerp(velocity, playerInput * SPEED, delta * ACCELERATION)
	
	move_and_slide()

func set_can_move(toggle: bool):
	if toggle:
		can_move = true
	else:
		can_move = false
		velocity = Vector2.ZERO

func set_camera_bounds(left_limit: int, right_limit: int):
	camera_2d.limit_left = left_limit
	camera_2d.limit_right = right_limit
