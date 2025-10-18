extends HBoxContainer

@onready var player_container: HBoxContainer = $PlayerContainer
@onready var enemy_container: HBoxContainer = $EnemyContainer

func update_tile_highlights(card_position_data:Array):
	var player_positions = card_position_data[0]
	var enemy_positions = card_position_data[1]
	
	player_container.highlight_tiles(player_positions)
	enemy_container.highlight_tiles(enemy_positions)

func clear_tile_highlights():
	player_container.un_highlight_tiles()
	enemy_container.un_highlight_tiles()
