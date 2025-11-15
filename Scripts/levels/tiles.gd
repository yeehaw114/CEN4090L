extends Node2D

@onready var player: PlayerExploration = $"../Player"

const test_level := preload("res://Assets/Resources/levels/test.tres")

const tile_scene := preload("res://Scenes/tile.tscn")
const first_tile_position := Vector2(50,68)
const tile_offset := Vector2(100,0)
const level_size := 10

signal player_position_updated(tile)
signal level_bounds_found(left_limit,right_limit)

var tiles := []


func _ready() -> void:
	populate_tiles()

func populate_tiles():
	var left_camera_limit : int
	var right_camera_limit : int
	for tile in test_level.tiles:
		var new_tile := tile_scene.instantiate()
		new_tile.call_deferred("set_resource", tile)
		new_tile.player_entered.connect(update_player_position)
		add_child(new_tile)
		if tiles.is_empty(): 
			new_tile.position = first_tile_position
		else:
			new_tile.position = tiles[-1].position + tile_offset
		tiles.append(new_tile)
		print('tile pos: '+str(new_tile.position))
		if tile.wall and !left_camera_limit:
			left_camera_limit = tiles[-1].position.x
			print('left camera limit: '+str(left_camera_limit))
		elif tile.wall and left_camera_limit:
			right_camera_limit = tiles[-1].position.x
			print('right camera limit: '+str(right_camera_limit))
	
	await get_tree().process_frame
	level_bounds_found.emit(left_camera_limit,right_camera_limit)

func update_player_position(tile):
	for t in tiles:
		tile.player = null
	tile.player = player
	player_position_updated.emit(tile)
	print(str(tile) + " has " + str(tile.player))
