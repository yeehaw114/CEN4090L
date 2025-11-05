extends Character
class_name Player

const grey_shader = preload("res://Assets/Shaders/grey.gdshader")
const status_effect_scene = preload("res://Scenes/status_effect.tscn")
const BLUR_CONSTANT = 2.5

@export var inv: Inv

@onready var select_ring: Sprite2D = $SelectRing
@onready var enemy_sprite: TextureRect = $HBoxContainer/VBoxContainer/EnemySprite
@onready var health_bar: ProgressBar = $HBoxContainer/VBoxContainer/HealthBar
@onready var block_texture: TextureRect = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture
@onready var block_label: Label = $HBoxContainer/VBoxContainer/HealthBar/BlockTexture/BlockLabel
@onready var status_effect_container: GridContainer = $HBoxContainer/StatusEffectContainer
@onready var health_value_label: Label = $HBoxContainer/VBoxContainer/HealthBar/HealthValueLabel
@onready var player_sound_manager: Node2D = $PlayerSoundManager

var is_able_to_be_selected = false
var is_dead = false
var rank : int = -1 
var block_value := 0 

var damage_modifier := 0
var damage_increase := 0
var damage_decrease := 0

var block_modifier := 0
var block_increase := 0
var block_decrease := 0

signal player_died
signal took_damage(damage: int)

func _ready():
	enemy_sprite.texture = sprite
	health_bar.value = GameState.current_health
	health_bar.max_value = GameState.max_health
	health = GameState.current_health
	max_health = GameState.max_health
	health_value_label.text = str(GameState.current_health)+'/'+str(GameState.max_health)

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
	var health_before_damage = health
	health -= damage
	if !health_before_damage == health:
		took_damage.emit(damage)
		player_sound_manager.play_hurt()
		health_value_label.text = str(health)+'/'+str(max_health)
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

func die():
	is_dead = true
	set_grey_shader()
	player_died.emit()

func set_status_effect(status_effect: StatusEffect, value: int):
	if status_effect._type == StatusEffect.type["BUFF"]:
		player_sound_manager.play_buff()
	elif status_effect._type == StatusEffect.type["DEBUFF"]:
		player_sound_manager.play_debuff()
	
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
		elif status._type == status.type.BUFF:
			apply_buffs()
		elif status._type == status.type.DEBUFF:
			apply_debuffs()
	set_damage_and_block_modifer()

func apply_buffs():
	for status in status_effects:
		if status._type == status.type.BUFF:
				match status._stat:
					status.stat.DAMAGE:
						damage_increase = status.count
						print('---------------\nDAMAGE_INCREASE: '+str(damage_increase))
						print('DAMAGE_DECREASE: '+str(damage_decrease))
					status.stat.BLOCK:
						block_increase = status.count
					status.stat.CRIT:
						pass
	set_damage_and_block_modifer()

func apply_debuffs():
	for status in status_effects:
		if status._type == status.type.DEBUFF:
			match status._stat:
				status.stat.DAMAGE:
					damage_decrease = status.count
					print('\n'+'UPDATING DAMAGE MODIFER: '+str(damage_modifier))
				status.stat.BLOCK:
					block_decrease = status.count
					print('\n'+'UPDATING BLOCK MODIFER: '+str(block_modifier))
				status.stat.CRIT:
					pass
	set_damage_and_block_modifer()

func clear_status_effects():
	for status_nodes in get_status_effect_nodes():
		status_nodes.queue_free()
	status_effects.clear()

func set_damage_and_block_modifer():
	damage_modifier = damage_increase - damage_decrease
	block_modifier = block_increase - block_decrease
	print('UPDATING DAMAGE MODIFER: '+str(damage_modifier))
