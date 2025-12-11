extends CharacterBody3D
class_name PlayerExploration

@onready var camera_3d: Camera3D = $Camera3D

const SPEED = 10
const ACCELERATION = 10.0

var input: Vector3
var can_move := true
var right_bound: float = 10
var left_bound: float = 0

func get_input() -> Vector3:
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = 0
	input.z = 0
	return input.normalized()

func _physics_process(delta: float) -> void:
	var playerInput = get_input()
	if can_move:
		velocity = velocity.lerp(playerInput * SPEED, delta * ACCELERATION)
	else:
		velocity = Vector3.ZERO  # ensures no sliding if movement disabled
		
	
	move_and_slide()
	update_camera()

func set_can_move(toggle: bool):
	can_move = toggle
	if !toggle:
		velocity = Vector3.ZERO

func update_camera():
	# make camera follow the player X
	camera_3d.global_position.x = global_position.x

	# now clamp AFTER movement
	camera_3d.global_position.x = clamp(
		camera_3d.global_position.x,
		left_bound,
		right_bound - 4
	)

func set_camera_bounds(left_limit,right_limit):
	left_bound = left_limit
	right_bound = right_limit
