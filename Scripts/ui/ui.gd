extends Control
@onready var rank_4_position: Control = $CharacterContainer/PlayerContainer/Rank4Container/Rank4Position
@onready var rank_4_position2: Control = $CharacterContainer/PlayerContainer/RankContainer2/Rank4Position

func _ready() -> void:
	pass
	print(rank_4_position.global_position)
	print(rank_4_position.position)
	print(rank_4_position2.global_position)
	
