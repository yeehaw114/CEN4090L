extends Character
class_name Enemy

const grey_shader = preload("res://Assets/Shaders/grey.gdshader")

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var health_bar: ProgressBar = $HealthBar
@onready var intention_texture: TextureRect = $IntentionContainer/IntentionTexture
@onready var intention_label: Label = $IntentionContainer/IntentionLabel

@export var actions: Array[Action]

var current_action : Action
var is_able_to_be_selected = false
var is_dead = false
var rank : int = -1 

func _ready():
	enemy_sprite.texture = sprite
	health_bar.value = health

func mouse_entered_body() -> void:
	if is_able_to_be_selected:
		select_ring.visible = true
	else:
		select_ring.visible = false
	
func mouse_exited_body() -> void:
	select_ring.visible = false

func take_damage(damage: int):
	health -= damage
	health_bar.value = health
	if check_if_dead():
		set_grey_shader()
		is_dead = true

func turn_selectibility_off() ->void:
	select_ring.visible = false
	is_able_to_be_selected = false
	
func turn_selectibility_on() ->void:
	if !check_if_dead():
		is_able_to_be_selected = true

func check_if_dead() -> bool:
	if health <= 0:
		return true
	else:
		return false
		
func set_grey_shader() -> void:
	var shader_mat = ShaderMaterial.new()
	shader_mat.shader = grey_shader
	enemy_sprite.material = shader_mat
	
func set_current_action(index: int):
	current_action = actions[index]

func update_intention():
	intention_label.text = str(current_action.value)
