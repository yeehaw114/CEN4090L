extends Node2D

@onready var player_rank_4_position: Node2D = $player_rank4_position
@onready var player_rank_3_position: Node2D = $player_rank3_position
@onready var player_rank_2_position: Node2D = $player_rank2_position
@onready var player_rank_1_position: Node2D = $player_rank1_position

func _ready():
	for r in get_children():
		print(r.global_position)

func get_tile_position():
	pass
