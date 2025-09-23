extends Control

@export var cell_scene: PackedScene = preload("res://Scenes/card.tscn")
@export var grid_width: int = 2
@export var grid_height: int = 2
@export var cell_size: Vector2 = Vector2(36*2, 48*2)

@onready var grid_container: GridContainer = $VBoxContainer/GridContainer

func _ready():
	populate_grid()

func populate_grid():
	for y in range(grid_height):
		for x in range(grid_width):
			var cell_instance = cell_scene.instantiate()
			grid_container.add_child(cell_instance)
			cell_instance.position = Vector2(x * cell_size.x, y * cell_size.y)
			# Optional: Add custom logic or data to the cell_instance
			# cell_instance.grid_position = Vector2i(x, y)
