extends CharacterBody2D

@export var tilemap : TileMap

@export var offset_left: float = 0.0
@export var offset_right: float = 0.0
@export var offset_top: float = 0.0
@export var offset_bottom: float = 0.0

const SPEED = 200.0

const raycast_right = Vector2(25,0)
const raycast_left = Vector2(-25,0)
const raycast_up = Vector2(0,-25)
const raycast_down = Vector2(0,25)

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var interact_raycast: RayCast2D = $InteractRaycast

var last_facing = "down"
var locked_direction = Vector2.ZERO
var first_input_locked = false
var able_to_move := true

func _ready() -> void:
	limit_camera(tilemap)

func _physics_process(_delta):
	handle_movement_input()
	
	if Input.is_action_just_pressed("Interact"):
		if check_for_interactable():
			var object = get_raycast_object()
			if object.name == 'CardViewerCollision':
				object.display_card_viewer()
				toggle_able_to_move(false)
			elif object.name == 'ChestCollision':
				object.open()
			
	
	velocity = locked_direction * SPEED
	move_and_slide()
	
	update_animation()

func check_for_interactable() -> bool:
	if interact_raycast.is_colliding():
		var obj = interact_raycast.get_collider()
		return true
	return false
	
func get_raycast_object():
	if interact_raycast.is_colliding():
		return interact_raycast.get_collider()

func toggle_able_to_move(toggle: bool):
	if toggle:
		able_to_move = true
		return
	able_to_move = false

func handle_movement_input():
	if !able_to_move:
		return
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
			interact_raycast.target_position = raycast_right
		elif locked_direction == Vector2.LEFT:
			last_facing = "left"
			interact_raycast.target_position = raycast_left
		elif locked_direction == Vector2.DOWN:
			last_facing = "down"
			interact_raycast.target_position = raycast_down
		elif locked_direction == Vector2.UP:
			last_facing = "up"
			interact_raycast.target_position = raycast_up
		
		var anim_name = "run_" + last_facing
		if animated_sprite.animation != anim_name:
			if last_facing == 'right':
				animated_sprite.flip_h = false
			if last_facing == 'left':
				animated_sprite.flip_h = true
			animated_sprite.play(anim_name)
	else:
		# Idle animation in last movement direction
		var idle_anim = "idle_" + last_facing
		if animated_sprite.animation != idle_anim:
			animated_sprite.play(idle_anim)

func limit_camera(tilemap: TileMap):
	if tilemap:
		# Get the used rectangle of the TileMap in cell coordinates
		var used_rect = tilemap.get_used_rect()
		var cell_size = tilemap.tile_set.tile_size
		
		# Convert to pixel space
		var map_min = tilemap.map_to_local(used_rect.position)
		var map_max = tilemap.map_to_local(used_rect.position + used_rect.size)
		
		# Set camera limits
		camera_2d.limit_left   = int(map_min.x - offset_left)
		camera_2d.limit_top    = int(map_min.y - offset_top)
		camera_2d.limit_right  = int(map_max.x + offset_right)
		camera_2d.limit_bottom = int(map_max.y + offset_bottom)
	else:
		push_warning("TileMap not found: %s" % str(tilemap))


func _on_shop_trigger_body_entered(body: Node2D) -> void:
	#Stop the player from moving
	pass
