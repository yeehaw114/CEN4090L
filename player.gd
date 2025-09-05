extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 4.0

var input: Vector2

func get_input() -> Vector2:
	input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()

func _init() -> void:
	pass
	
func _process(delta: float) -> void:
	var playerInput = get_input()
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCELERATION)
	
	move_and_slide()
