extends CharacterBody2D
const SPEED = 200.0
@onready var animated_sprite = $AnimatedSprite2D
var last_facing = "down"

func _physics_process(_delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * SPEED
	move_and_slide()

	if input_vector != Vector2.ZERO:
		# Choose walk animation based on direction
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				last_facing = "right"
			else:
				last_facing = "left"
		else:
			if input_vector.y > 0:
				last_facing = "down"
			else:
				last_facing = "up"
		var anim_name = "run_" + last_facing
		if animated_sprite.animation != anim_name:
			animated_sprite.play(anim_name)
	else:
		# Idle animation in last movement direction
		var idle_anim = "idle_" + last_facing
		if animated_sprite.animation != idle_anim:
			animated_sprite.play(idle_anim)
