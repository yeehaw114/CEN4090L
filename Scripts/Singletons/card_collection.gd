extends Node

var all_cards : Array[CardResource] = []
var card_file_path := "res://Assets/Resources/cards/final_cards/"

func _ready() -> void:
	get_all_cards()

func get_all_cards():
	# Open dir
	var dir := DirAccess.open(card_file_path)
	if dir == null:
		push_error("Could not open directory: " + card_file_path)
		return
		
	var cards: Array[CardResource] = []

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# skip directories and hidden entries like '.' '..'
		if not dir.current_is_dir() and not file_name.begins_with("."):
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var file_path := card_file_path + file_name
				var card_resource := ResourceLoader.load(file_path)
				if card_resource:
					cards.append(card_resource)
				else:
					push_warning("Failed to load resource: " + file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	all_cards = cards

func get_all_locked_cards() -> Array[CardResource]:
	var locked_cards : Array[CardResource] = []
	for card in all_cards:
		if card.is_locked:
			locked_cards.append(card)
	return locked_cards
	
func get_all_unlocked_cards() -> Array[CardResource]:
	var locked_cards : Array[CardResource] = []
	for card in all_cards:
		if !card.is_locked:
			locked_cards.append(card)
	return locked_cards
	
func set_card_to_unlocked(card_new: CardResource):
	var locked_cards = get_all_locked_cards()
	for card in locked_cards:
		if card == card_new:
			card.is_locked = false

func get_reward_options() -> Array[CardResource]:
	get_all_cards()
	var reward_cards : Array[CardResource] = []
	for card in all_cards:
		if !card.is_locked and !card.is_unlocked_at_start:
			reward_cards.append(card)
	return reward_cards
	
