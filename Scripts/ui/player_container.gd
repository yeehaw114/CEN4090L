extends HBoxContainer

@onready var rank_container: PanelContainer = $RankContainer
@onready var rank_container_2: PanelContainer = $RankContainer2
@onready var rank_container_3: PanelContainer = $RankContainer3
@onready var rank_container_4: PanelContainer = $RankContainer4

func set_player_placement(rank):
	pass

func get_tile(rank:int):
	for t in get_children():
		#print(t.character_position_point.global_position) # global
		if t.rank == rank:
			#print(t)
			return t

func get_tile_by_char(character: Character):
	for t in get_children():
		if t.character == character:
			return t
	return null
