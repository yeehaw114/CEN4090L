extends Character
class_name Enemy

const grey_shader = preload("res://Assets/Shaders/grey.gdshader")
const attack_intention_texture = preload("res://Assets/Textures/attack_intenttion.png")
const block_intention_texture = preload("res://Assets/Textures/block_intention.png")

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: TextureRect = $HBoxContainer/VBoxContainer/EnemySprite
@onready var health_bar: ProgressBar = $HBoxContainer/VBoxContainer/HealthBar
@onready var intention_texture: TextureRect = $HBoxContainer/VBoxContainer/IntentionContainer/IntentionTexture
@onready var intention_label: Label = $HBoxContainer/VBoxContainer/IntentionContainer/IntentionLabel
@onready var block_label: Label = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture/BlockLabel
@onready var block_texture: TextureRect = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture

@export var actions: Array[Action]

@export var enemy_resource: EnemyResource

var current_action : Action
var is_able_to_be_selected = false
var is_dead = false
var rank : int = -1
var block_value := 0 

func _ready():
	enemy_sprite.texture = enemy_resource.enemy_texture
	health_bar.value = enemy_resource.max_health
	health_bar.max_value = enemy_resource.max_health
	health = enemy_resource.max_health
	actions = enemy_resource.actions
	set_current_action(0)
	print('\nENEMY ACTIONS: '+str(actions))
	print('CURRENT ACTION: '+str(current_action))

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
	
func set_current_action(index: int):
	current_action = actions[index]
	update_intention()

func update_intention():
	intention_label.text = str(current_action.value)
	if current_action.type == Action.ACTION_TYPE.DAMAGE:
		intention_texture.texture = attack_intention_texture
	if current_action.type == Action.ACTION_TYPE.BLOCK:
		intention_texture.texture = block_intention_texture

func next_action():
	var index = actions.find(current_action)
	if index == actions.size()-1:
		set_current_action(0)
		print(0)
		return
	set_current_action(index+1)
	print(index+1)

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
