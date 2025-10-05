extends CharacterBody2D

const SPEED = 200.0
@onready var animated_sprite = $AnimatedSprite2D
var last_facing = "down"
var locked_direction = Vector2.ZERO
var first_input_locked = false

func _physics_process(_delta):
	handle_movement_input()
	
	velocity = locked_direction * SPEED
	move_and_slide()
	
	update_animation()

func handle_movement_input():
	# If no direction is locked, check for new input
	if not first_input_locked:
		if Input.is_action_pressed("ui_up"):
			locked_direction = Vector2.UP
			first_input_locked = true
		elif Input.is_action_pressed("ui_down"):
			locked_direction = Vector2.DOWN
			first_input_locked = true
		elif Input.is_action_pressed("ui_left"):
			locked_direction = Vector2.LEFT
			first_input_locked = true
		elif Input.is_action_pressed("ui_right"):
			locked_direction = Vector2.RIGHT
			first_input_locked = true
	
	# Check if the locked direction key is still being pressed
	if first_input_locked:
		var still_pressed = false
		
		if locked_direction == Vector2.UP and Input.is_action_pressed("ui_up"):
			still_pressed = true
		elif locked_direction == Vector2.DOWN and Input.is_action_pressed("ui_down"):
			still_pressed = true
		elif locked_direction == Vector2.LEFT and Input.is_action_pressed("ui_left"):
			still_pressed = true
		elif locked_direction == Vector2.RIGHT and Input.is_action_pressed("ui_right"):
			still_pressed = true
		
		# If the locked key is released, unlock direction
		if not still_pressed:
			locked_direction = Vector2.ZERO
			first_input_locked = false

func update_animation():
	if locked_direction != Vector2.ZERO:
		# Moving - choose animation based on locked direction
		if locked_direction == Vector2.RIGHT:
			last_facing = "right"
		elif locked_direction == Vector2.LEFT:
			last_facing = "left"
		elif locked_direction == Vector2.DOWN:
			last_facing = "down"
		elif locked_direction == Vector2.UP:
			last_facing = "up"
		
		var anim_name = "run_" + last_facing
		if animated_sprite.animation != anim_name:
			animated_sprite.play(anim_name)
	else:
		# Idle animation in last movement direction
		var idle_anim = "idle_" + last_facing
		if animated_sprite.animation != idle_anim:
			animated_sprite.play(idle_anim)
