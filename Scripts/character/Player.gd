extends Character
class_name Player

const grey_shader = preload("res://Assets/Shaders/grey.gdshader")

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: TextureRect = $HBoxContainer/VBoxContainer/EnemySprite
@onready var health_bar: ProgressBar = $HBoxContainer/VBoxContainer/HealthBar
@onready var block_texture: TextureRect = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture
@onready var block_label: Label = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture/BlockLabel

var is_able_to_be_selected = false
var is_dead = false
var rank : int = -1 
var block_value := 0 

func _ready():
	enemy_sprite.texture = sprite
	health_bar.value = health
	health_bar.max_value = health

func mouse_entered_body() -> void:
	if is_able_to_be_selected:
		select_ring.visible = true
	else:
		select_ring.visible = false
	
func mouse_exited_body() -> void:
	select_ring.visible = false

func take_damage(damage: int):
	if block_value > 0:
		var new_block := 0
		new_block = block_value - damage
		damage -= block_value
		if damage < 0:
			damage = 0
		print('damage after block: '+str(damage))
		set_block_value(new_block)
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

func add_and_set_block_value(num: int):
	block_value += num
	if block_value > 0:
		block_label.text = str(block_value)
		block_texture.visible = true
	else:
		clear_block_value()
	
func clear_block_value():
	block_value = 0
	block_label.text = ''
	block_texture.visible = false

func remove_block_value(num: int):
	block_value -= num
	if block_value <= 0:
		clear_block_value()
	else:
		block_label.text = str(block_value)

func set_block_value(num: int):
	if num < 0:
		num = 0
	block_value = num
	block_texture.visible = true
	block_label.text = str(num)
