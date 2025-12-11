extends Control

@onready var left_miss: Zone = $BarContainer/HBoxContainer/LeftMiss
@onready var right_miss: Zone = $BarContainer/HBoxContainer/RightMiss
@onready var pointer: Sprite2D = $Pointer

@onready var left_bound_marker: Marker2D = $BoundMarker
@onready var right_bound_marker: Marker2D = $BoundMarker2

enum TYPE {MISS,BAD,OK,GREAT}

signal finsihed(zone: TYPE)

var active := false
var lerp_amount = 0.0 # Will increase over time for animation
var start_position : Vector2
var end_position : Vector2
var current_zone : TYPE

func _ready() -> void:
	pointer.global_position.x = right_bound_marker.global_position.x
	start_position = left_bound_marker.global_position
	end_position = right_bound_marker.global_position
	hide_check()
	
func _process(delta):
	move_pointer(delta)
	if Input.is_action_just_pressed("Interact") and active:
		print(current_zone)
		finsihed.emit(current_zone)
		active = false
		hide_check()

func move_pointer(delta):
	lerp_amount += delta * 1.1# Adjust 0.5 for desired speed
	lerp_amount = clamp(lerp_amount, 0.0, 1.0)
	
	# Calculate the interpolated position
	pointer.global_position = start_position.lerp(end_position, lerp_amount)
	
	if lerp_amount >= 1.0:
		# For example, swap start and end positions to go back and forth
		var temp = start_position
		start_position = end_position
		end_position = temp
		lerp_amount = 0.0


func on_zone_entered(area: Area2D, zone: int) -> void:
	if zone == TYPE.MISS:
		current_zone = TYPE.MISS
	elif zone == TYPE.BAD:
		current_zone = TYPE.BAD
	elif zone == TYPE.OK:
		current_zone = TYPE.OK
	elif zone == TYPE.GREAT:
		current_zone = TYPE.GREAT


func _on_skill_check_begin() -> void:
	await get_tree().create_timer(0.3).timeout
	active = true
	show_check()

func show_check():
	show()
	
func hide_check():
	hide()
