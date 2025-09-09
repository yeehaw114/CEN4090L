extends Character
class_name Enemy

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var health_bar: ProgressBar = $HealthBar

var is_able_to_be_selected = false

func _ready():
	enemy_sprite.texture = sprite
	health_bar.value = health

func selected():
	select_ring.visible = true
	
func unselected():
	select_ring.visible = false

func mouse_entered_body() -> void:
	if is_able_to_be_selected:
		select_ring.visible = true
	
func mouse_exited_body() -> void:
	select_ring.visible = false
