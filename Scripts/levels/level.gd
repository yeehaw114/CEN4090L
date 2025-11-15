extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var player: PlayerExploration = $Player

const event_scene := preload("res://Scenes/event.tscn")

func show_new_event(event_resource : EventResource):
	var new_event = event_scene.instantiate()
	new_event.eventResource = event_resource
	new_event.event_finished.connect(set_player_move.bind(true))
	canvas_layer.add_child(new_event)
	set_player_move(false)
	print('showing new event')

func set_player_move(toggle: bool):
	if toggle:
		player.set_can_move(true)
	else:
		player.set_can_move(false)

func _on_tiles_player_position_updated(tile: Variant) -> void:
	if tile.tile_resource.surprise_event and !tile.cleared:
		show_new_event(tile.tile_resource.surprise_event)
		tile.cleared = true
	elif tile.tile_resource.enemy and !tile.cleared:
		var tree = get_tree()
		var current_room = tree.current_scene
		var battle = tile.tile_resource.enemy
		battle.starting_cards.clear()
		battle.starting_cards = GameState.transferred_cards.duplicate(true)
		GameState.pending_battle_resource = battle
		tree.root.remove_child(current_room)
		GameState.previous_scene = current_room
		tile.cleared = true
		#Change scene to battle
		GameState.change_scene(GameState.SCENES["battle"])
