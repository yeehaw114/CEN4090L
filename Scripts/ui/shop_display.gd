extends Control

@onready var card_left: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Card
@onready var card_middle: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/Card
@onready var card_right: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/Card

@onready var left_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/LeftCostLabel
@onready var middle_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/MiddleCostLabel
@onready var right_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/RightCostLabel


var card_file_path := "res://Assets/Resources/cards/final_cards/"

var card_resources : Array[CardResource] = []
signal toggle_display(toggle: bool)

func _ready() -> void:
	get_all_locked_cards()
	update_cards(card_resources)

func update_card_resources(cards : Array[CardResource]):
	card_resources = cards

func update_cards(card_resources : Array[CardResource]):
	card_resources.shuffle()

	var card_nodes = [card_left, card_middle, card_right]
	var label_nodes = [left_cost_label,middle_cost_label,right_cost_label]

	for i in range(card_nodes.size()):
		if i < card_resources.size():
			card_nodes[i].card_stats = card_resources[i]
			card_nodes[i].set_values()
			card_nodes[i].show()
			label_nodes[i].show()
		else:
			card_nodes[i].hide() # hide unused slots if there aren't enough cards
			label_nodes[i].hide()

func get_all_locked_cards():
	# Open dir
	var dir := DirAccess.open(card_file_path)
	if dir == null:
		push_error("Could not open directory: " + card_file_path)
		return
		
	var locked: Array[CardResource] = []

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
					push_warning("Failed to load resource: " + file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	card_resources = locked

func _on_exit_button_pressed() -> void:
	hide()
	toggle_display.emit(true)

func _on_shop_object_interacted_with() -> void:
	show()
	toggle_display.emit(false)
