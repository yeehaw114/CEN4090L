extends CharacterBody2D

const SPEED = 200.0

@onready var animated_sprite = $AnimatedSprite2D
var facing_right = true

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	velocity = input_vector * SPEED
	move_and_slide()

	# Determine facing direction
	if input_vector.x > 0:
		facing_right = true
	elif input_vector.x < 0:
		facing_right = false

	var idle_anim = "idle_right" if facing_right else "idle_left"
	var walk_anim = "walk_right" if facing_right else "walk_left"

	if input_vector.length() > 0:
		if animated_sprite.animation != walk_anim:
			animated_sprite.play(walk_anim)
	else:
		if animated_sprite.animation != idle_anim:
			animated_sprite
