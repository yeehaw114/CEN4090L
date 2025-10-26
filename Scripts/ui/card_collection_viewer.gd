extends Control

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

var card_file_path := "res://Assets/Resources/cards/final_cards/"
const card_scene := preload("res://Scenes/card.tscn")

func _ready() -> void:
	call_deferred('populate_grid')

func populate_grid():
	# Clear existing cards if any
	for child in grid_container.get_children():
		child.queue_free()
	
	# Get the directory contents
	var dir := DirAccess.open(card_file_path)
	if dir == null:
		push_error("Could not open directory: " + card_file_path)
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# Skip subdirectories
		if not dir.current_is_dir():
			# Only load .tres or .res files
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var file_path := card_file_path + file_name
				var card_resource := ResourceLoader.load(file_path)
				
				if card_resource:
					var card_instance = card_scene.instantiate()
					card_instance.card_stats = card_resource
					grid_container.add_child(card_instance)
					card_instance.call_deferred("set_values")  # ensures labels are ready
					grid_container.add_child(card_instance)
				else:
					push_warning("Failed to load resource: " + file_path)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
