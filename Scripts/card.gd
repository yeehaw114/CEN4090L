extends Control
class_name Card

const SIZE := Vector2(32,48)

@export var card_stats: CardResource
@export var is_reward: bool

@onready var cost_label: Label = $BaseCardSprite/CostLabel
@onready var description_label: Label = $BaseCardSprite/DescriptionLabel
@onready var name_label: Label = $BaseCardSprite/NameLabel

@onready var player_rank_4_texture: TextureRect = $BaseCardSprite/playerRank4Texture
@onready var player_rank_3_texture: TextureRect = $BaseCardSprite/playerRank3Texture
@onready var player_rank_2_texture: TextureRect = $BaseCardSprite/playerRank2Texture
@onready var player_rank_1_texture: TextureRect = $BaseCardSprite/playerRank1Texture
@onready var enemy_rank_1_texture: TextureRect = $BaseCardSprite/enemyRank1Texture
@onready var enemy_rank_2_texture: TextureRect = $BaseCardSprite/enemyRank2Texture
@onready var enemy_rank_3_texture: TextureRect = $BaseCardSprite/enemyRank3Texture
@onready var enemy_rank_4_texture: TextureRect = $BaseCardSprite/enemyRank4Texture


var is_currently_selected: bool = false
var is_able_to_be_selected: bool = true

func set_values() -> void:
	if card_stats:
		cost_label.text = str(card_stats.card_cost)
		description_label.text = card_stats.card_description
		name_label.text = card_stats.card_name
		for pos in card_stats.character_position:
			if pos == CardResource.rank.ONE:
				player_rank_1_texture.visible = true
			if pos == CardResource.rank.TWO:
				player_rank_2_texture.visible = true
			if pos == CardResource.rank.THREE:
				player_rank_3_texture.visible = true
			if pos == CardResource.rank.FOUR:
				player_rank_4_texture.visible = true
		for pos in card_stats.enemy_position:
			if pos == CardResource.rank.ONE:
				enemy_rank_1_texture.visible = true
			if pos == CardResource.rank.TWO:
				enemy_rank_2_texture.visible = true
			if pos == CardResource.rank.THREE:
				enemy_rank_3_texture.visible = true
			if pos == CardResource.rank.FOUR:
				enemy_rank_4_texture.visible = true
	
func _ready() -> void:
	#print('ready: '+str(card_stats))
	set_values()

func mouse_entered_card_area() -> void:
	if is_currently_selected or !is_able_to_be_selected or is_reward:
		return
	increase_scale(1)

func mouse_exited_card_area() -> void:
	if is_currently_selected or !is_able_to_be_selected or is_reward:
		return
	decrease_scale(1)

func increase_scale(n: int):
	#scale = scale + Vector2(n,n)
	pass
	
func decrease_scale(n: int):
	#scale = scale - Vector2(n,n)
	pass
	
func reset_scale_and_position():
	#scale = Vector2(2,2)
	#position.y = 450
	pass
