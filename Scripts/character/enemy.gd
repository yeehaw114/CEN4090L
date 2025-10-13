extends Character
class_name Enemy

const grey_shader = preload("res://Assets/Shaders/grey.gdshader")
const attack_intention_texture = preload("res://Assets/Textures/attack_intenttion.png")
const block_intention_texture = preload("res://Assets/Textures/block_intention.png")
const status_effect_scene = preload("res://Scenes/status_effect.tscn")
const BLUR_CONSTANT = 2.5

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: TextureRect = $VBoxContainer/HBoxContainer/VBoxContainer/EnemySprite
@onready var health_bar: ProgressBar = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HealthBar
@onready var intention_texture: TextureRect = $VBoxContainer/IntentionContainer/IntentionTexture
@onready var intention_label: Label = $VBoxContainer/IntentionContainer/IntentionLabel
@onready var block_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HealthBar/BlockTexture/BlockLabel
@onready var block_texture: TextureRect = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HealthBar/BlockTexture
@onready var status_effect_container: GridContainer = $VBoxContainer/HBoxContainer/StatusEffectContainer
@onready var health_value_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/HealthBar/HealthValueLabel

@export var actions: Array[Action]

@export var enemy_resource: EnemyResource

signal enemy_died
signal took_damage(damage: int)

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
	health_value_label.text = str(health)+'/'+str(health)
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
	print('\n'+str(self)+' is taking '+str(damage))
	if block_value > 0:
		var new_block := 0
		new_block = block_value - damage
		damage -= block_value
		if damage < 0:
			damage = 0
		print('damage after block: '+str(damage))
		set_block_value(new_block)
	var health_before_damage = health
	health -= damage
	if !health_before_damage == health:
		took_damage.emit(damage)
		health_value_label.text = str(health)+'/'+str(enemy_resource.max_health)
	health_bar.value = health
	if check_if_dead():
		die()

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
	if is_dead:
		hide_intention()
		return
	intention_label.text = str(current_action.value)
	if current_action.type == Action.ACTION_TYPE.DAMAGE:
		intention_texture.texture = attack_intention_texture
	if current_action.type == Action.ACTION_TYPE.BLOCK:
		intention_texture.texture = block_intention_texture

func hide_intention():
	intention_label.modulate = Color(1, 1, 1, 0)
	intention_texture.modulate = Color(1, 1, 1, 0)

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
	if block_value == 0:
		clear_block_value()
		return
	block_texture.visible = true
	block_label.text = str(num)

func die():
	is_dead = true
	set_grey_shader()
	update_intention()
	clear_block_value()
	clear_status_effects()
	health_value_label.text = '0/0'
	enemy_died.emit()

func set_status_effect(status_effect: StatusEffect, value: int):
	for effect in status_effects:
		if effect.name == status_effect.name:
			for e in get_status_effect_nodes():
				if e.status_effect_resource.name == status_effect.name:
					print('\nADDING TO STATUS EFFECT: '+e.status_effect_resource.name+
							' COUNT: '+str(value)+'\n')
					e.status_effect_resource.count += value
					#effect.count += value
					e.set_data()
					return
	
	var new_effect = status_effect.duplicate(true)
	new_effect.count += value
	status_effects.append(new_effect)
	
	var new_status_effect = status_effect_scene.instantiate()
	new_status_effect.status_effect_resource = new_effect
	status_effect_container.add_child(new_status_effect)
	print('\nADDING NEW STATUS EFFECT: '+new_status_effect.name+'\n')
	new_status_effect.set_data()
	
func get_status_effect_nodes():
	return status_effect_container.get_children()

func aply_status_effects():
	if is_dead:
		return
	for status in status_effects:
		if status._type == status.type.DOT:
			print('\nAPPLYING STATUS EFFECT: '+str(status)+' COUNT: '+str(status.count))
			take_damage(status.count)

func clear_status_effects():
	for status_nodes in get_status_effect_nodes():
		status_nodes.queue_free()
	status_effects.clear()
