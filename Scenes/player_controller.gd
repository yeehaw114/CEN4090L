extends CharacterBody2D

const SPEED = 200.0

@onready var animated_sprite = $AnimatedSprite2D
var last_facing_right = true

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	velocity = input_vector * SPEED
	move_and_slide()

	# Update last facing direction when moving horizontally
	if input_vector.x > 0:
		last_facing_right = true
		if animated_sprite.animation != "walk_right":
			animated_sprite.play("walk_right")
	elif input_vector.x < 0:
		last_facing_right = false
		if animated_sprite.animation != "walk_left":
			animated_sprite.play("walk_left")
	else:
		# No horizontal movement; use last facing direction for idle
		var idle_anim = "idle_right" if last_facing_right else "idle_left"
		if animated_sprite.animation != idle_anim:
			animated_sprite.play(idle_anim)
