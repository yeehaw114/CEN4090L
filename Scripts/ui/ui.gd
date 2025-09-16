extends Control
@onready var rank_4_position: Control = $CharacterContainer/PlayerContainer/Rank4Container/Rank4Position
@onready var rank_4_position2: Control = $CharacterContainer/PlayerContainer/RankContainer2/Rank4Position
@onready var rank_4_container: PanelContainer = $CharacterContainer/PlayerContainer/Rank4Container
@onready var rank_container_2: PanelContainer = $CharacterContainer/PlayerContainer/RankContainer2

@onready var player: Enemy = $BattleManager/Player

func _ready() -> void:
	pass
	print(rank_4_position.get_global_rect().position)
	print(rank_4_position2.get_global_rect().position)
	#player.position = rank_4_position.get_global_rect().position
	print(rank_4_container.get_global_rect().position)
	print(rank_container_2.get_global_rect().position)
