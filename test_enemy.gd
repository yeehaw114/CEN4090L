extends CharacterBody2D

@export var speed = 80
var player = null

@onready var detect_area = $DetectArea
@onready var body_area = $BodyArea

func _ready():
	detect_area.body_entered.connect(_on_detect_entered)
	detect_area.body_exited.connect(_on_detect_exited)
	body_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_detect_entered(body):
	if body.name == "Player":
		player = body

func _on_detect_exited(body):
	if body == player:
		player = null

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/battle_manager.tscn")
