extends Control

@onready var grid_container: GridContainer = $MarginContainer/Panel/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

signal toggle_display(toggle: bool)
signal populate_card_collection(cards: Array[CardResource])

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

	var unlocked = CardCollection.get_all_unlocked_cards()
	var locked = CardCollection.get_all_locked_cards()
	
	for res in unlocked + locked:
		var card_instance = card_scene.instantiate()
		card_instance.card_stats = res
		grid_container.add_child(card_instance)
		card_instance.call_deferred("set_values")
		if card_instance.card_stats.is_locked:
			card_instance.apply_greyscale()
			
	populate_card_collection.emit(locked)

	# Debug info
	print("populate_grid: unlocked=", unlocked.size(), " locked=", locked.size())
