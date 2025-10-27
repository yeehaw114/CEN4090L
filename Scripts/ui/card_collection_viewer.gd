extends Control

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

signal toggle_display(toggle: bool)

var card_file_path := "res://Assets/Resources/cards/final_cards/"
const card_scene := preload("res://Scenes/card.tscn")

func _ready() -> void:
	call_deferred('populate_grid')

func display():
	show()
	toggle_display.emit(false)
	
func undisplay():
	hide()
	toggle_display.emit(true)

func populate_grid():
	# Clear existing cards
	for child in grid_container.get_children():
		child.queue_free()

	# Open dir
	var dir := DirAccess.open(card_file_path)
	if dir == null:
		push_error("Could not open directory: " + card_file_path)
		return

	var unlocked: Array = []
	var locked: Array = []

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# skip directories and hidden entries like '.' '..'
		if not dir.current_is_dir() and not file_name.begins_with("."):
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var file_path := card_file_path + file_name
				var card_resource := ResourceLoader.load(file_path)
				if card_resource:
					# Defensive check: make sure is_locked property exists and is a bool
					if card_resource.is_locked:
						locked.append(card_resource)
					else:
						unlocked.append(card_resource)
				else:
					push_warning("Failed to load resource: " + file_path)
		file_name = dir.get_next()
	dir.list_dir_end()

	# Add unlocked first, then locked
	for res in unlocked + locked:
		var card_instance = card_scene.instantiate()
		card_instance.card_stats = res
		grid_container.add_child(card_instance)
		card_instance.call_deferred("set_values")
		if card_instance.card_stats.is_locked:
			card_instance.apply_greyscale()

	# Debug info
	print("populate_grid: unlocked=", unlocked.size(), " locked=", locked.size())
