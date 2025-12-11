extends Node3D

@onready var player: CharacterBody3D = $"../Player"

const test_level := preload("res://Assets/Resources/levels/test_3D.tres")

const tile_scene := preload("res://Scenes/level_3D/tile.tscn")
const first_tile_position := Vector3(-1,0,0)
const tile_offset := Vector3(3,0,0)
const level_size := 10

signal player_position_updated(tile)
signal level_bounds_found(left_limit,right_limit)
signal new_tile_cleared(progress: float)
signal level_won

var tiles : Array[Tile] = []
var explored_tiles : Array[Tile]
var explorable_tiles : Array[Tile]
var level_begin := false

func _ready() -> void:
	populate_tiles()

func populate_tiles():
	var left_camera_limit : int
	var right_camera_limit : int
	var left_bound_found := false
	for tile in test_level.tiles:
		var new_tile := tile_scene.instantiate()
		new_tile.call_deferred("set_resource", tile)
		#new_tile.set_resource(tile)
		
		new_tile.player_entered.connect(update_player_position)
		new_tile.player_interacted.connect(attempt_to_interact_with_tile)
		
		add_child(new_tile)
		if tiles.is_empty(): 
			new_tile.position = first_tile_position
		else:
			new_tile.position = tiles[-1].position + tile_offset
		tiles.append(new_tile)
		if tile.wall and not left_bound_found:
			left_bound_found = true
			left_camera_limit = new_tile.midpoint.global_position.x
			print('left camera limit: '+str(left_camera_limit))
		elif tile.wall and left_bound_found:
			right_camera_limit= new_tile.midpoint.global_position.x
			print('right_camera_limit: '+str(right_camera_limit))
	
	await get_tree().process_frame
	level_bounds_found.emit(left_camera_limit,right_camera_limit)
	level_begin = true
	get_all_explorable_tiles()
	get_percentage_level_complete()

func update_player_position(tile):
	#if !level_begin:
		#return
	for t in tiles:
		t.player = null
	tile.player = player
	player_position_updated.emit(tile)
	get_percentage_level_complete()
	#print(str(tile) + " has " + str(tile.player))

func attempt_to_interact_with_tile(tile):
	if not tile:
		return
	if not tile.player:
		return
	
	if tile.tile_resource.exit or tile.tile_resource.interactable:
		if tile.tile_resource.exit:
			level_won.emit()

func get_percentage_level_complete():
	var explored_tiles : Array[Tile]
	var explorable_tiles : Array[Tile]
	
	for tile in tiles:
		if !tile.tile_resource.starts_cleared:
			explorable_tiles.append(tile)
	
	for tile in explorable_tiles:
		if tile.cleared:
			explored_tiles.append(tile)
	
	var percentage_decimal = float(explored_tiles.size()) / float(explorable_tiles.size())
	var percentage_final = percentage_decimal * 100.0
	new_tile_cleared.emit(percentage_final)
	
	#for tile in explored_tiles:
		#print(str(tile.tile_resource.debug_name)+': '+str(tile.cleared))
	#print('player cleared: '+str(percentage_final)+'%\n')

func get_all_explorable_tiles() -> Array[Tile]:
	var explorable : Array[Tile] = []
	for tile in tiles:
		if !tile.tile_resource.wall:
			explorable.append(tile)
	explorable_tiles = explorable
	return explorable_tiles

func set_all_tiles_collision(toggle: bool):
	if toggle:
		for tile in tiles:
			tile.enable_collisions()
	else:
		for tile in tiles:
			tile.disable_collisions()
