extends Resource
class_name TileResource

var interactable
@export var enemy : BattleResource = null
@export var surprise_event : EventResource
@export var exit := false
@export var wall := false
@export var starts_cleared := false
@export var spawn_tile := false

@export_category("debug")
@export var debug_name := "tile"
