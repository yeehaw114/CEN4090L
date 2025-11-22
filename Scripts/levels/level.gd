extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var player: PlayerExploration = $Player
@onready var bottom_ui_panel: Panel = $CanvasLayer/BottomUIPanel
@onready var top_panel_container: PanelContainer = $CanvasLayer/TopPanelContainer
@onready var inventory_level: InventoryLevel = $CanvasLayer/BottomUIPanel/HBoxContainer/InventoryLevel

@onready var tiles: Node2D = $Tiles

const event_scene := preload("res://Scenes/event.tscn")
@export var player_inv : Inv
var event_inventory : Inv
@export var is_player_inventory := false

var hours_passed := 0
var current_tile : Tile

func _ready() -> void:
	print("LEVEL HAS INVENTORY LEVEL INSTANCE:", inventory_level)
	bottom_ui_panel.update_health(GameState.current_health)
	
	inventory_level.set_inventory(inventory_level.inventoryData)
	inventory_level.item_got.connect(attempt_to_insert_item)
	inventory_level.item_used.connect(apply_item_effect)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		attempt_to_interact_with_tile(current_tile)

func set_event_inventory(inv: Inv):
	event_inventory = inv
	print('\nplayer inv: '+str(player_inv))
	print('other inv: '+str(event_inventory))

func show_new_event(event_resource : EventResource):
	var new_event = event_scene.instantiate()
	new_event.eventResource = event_resource.duplicate(true)
	new_event.event_finished.connect(set_player_move.bind(true))
	new_event.result_inventory_decided.connect(set_event_inventory)
	canvas_layer.add_child(new_event)
	print('new event: '+str(new_event))
	set_player_move(false)
	#print('showing new event')

func set_player_move(toggle: bool):
	if toggle:
		player.set_can_move(true)
	else:
		player.set_can_move(false)

func _on_tiles_player_position_updated(tile: Variant) -> void:
	if not tile.can_react:
		return
	if tile.player != player:
		return  # ignore updates for other tiles
	
	var explorable = self.tiles.get_all_explorable_tiles()
	var previous_tile
	var index = explorable.find(tile)
	if index > 0:
		previous_tile = explorable[index - 1]
	else:
		#print("This node has no previous element.")
		pass
	
	current_tile = tile
	
	if tile.tile_resource.surprise_event and !tile.cleared:
		show_new_event(tile.tile_resource.surprise_event)
	elif tile.tile_resource.enemy and !tile.cleared:
		var tree = get_tree()
		var current_room = tree.current_scene
		var battle = tile.tile_resource.enemy
		battle.starting_cards.clear()
		battle.starting_cards = GameState.transferred_cards.duplicate(true)
		GameState.pending_battle_resource = battle
		tree.root.remove_child(current_room)
		GameState.previous_scene = current_room
		GameState.change_scene(GameState.SCENES["battle"])
	if previous_tile and previous_tile.cleared:
		if not tile.cleared:
			tile.cleared = true
			PlayerInventory.take_nerve_damage(15)
			hours_passed += 1
			top_panel_container.set_time_progress(hours_passed)

func apply_item_effect(item: InvItem):
	if item.stat == InvItem.STAT.HEALTH:
		PlayerInventory.heal(item.value)
	elif item.stat == InvItem.STAT.NERVE:
		PlayerInventory.heal_nerve(item.value)

func attempt_to_insert_item(item: InvItem):
	print("ATTEMPT INSERT CALLED WITH:", item)
	inventory_level.inv.insert(item)

func attempt_to_interact_with_tile(tile: Tile):
	if not tile:
		return
	
	if tile.tile_resource.exit or tile.tile_resource.interactable:
		if tile.tile_resource.exit:
			get_tree().change_scene_to_file("res://Scenes/town.tscn")
