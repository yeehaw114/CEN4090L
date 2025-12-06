extends Node
# PlayerInventory Singleton
# Add this to your autoload/singleton list in Project Settings?? IDK how to do this, is this safe?

# Player Stats
var current_health: int = 20
var max_health: int = 20
var max_nerve := 100
var current_nerve := max_nerve - 40

var coins: int = 10
var coins_looted: int = 0

var level := 1
var accuracy := 95
var dodge := 10
var crit := 5

# Combat Stats
var weapon_resource : WeaponResource = preload("res://Inventory/Items/gear/weapons/iron_sword.tres")
var ranged_resource : RangedResource = preload("res://Inventory/Items/gear/weapons/bow.tres")
var armour_resource : ArmourResource = preload("res://Inventory/Items/gear/armour/cloak.tres")

func change_melee(weapon: WeaponResource):
	if weapon:
		weapon_resource = weapon

func change_ranged(weapon: RangedResource):
	if weapon:
		ranged_resource = weapon
	
func change_armour(armour: ArmourResource):
	if armour:
		armour_resource = armour

func get_damage_melee():
	return randi_range(weapon_resource.damage_min,weapon_resource.damage_max)
	
func get_damage_ranged():
	return randi_range(ranged_resource.damage_min,ranged_resource.damage_max)
	
func get_block():
	return randi_range(armour_resource.block_min,armour_resource.block_max)

# Inventory
var owned_cards: Array[Resource] = []  # All cards the player owns
var current_deck: Array[Resource] = []  # The 8 cards in the player's active deck
var max_deck_size: int = 8

# Flask/Healing Items
var healing_flasks: int = 3
var max_flasks: int = 3
var flask_heal_amount: int = 5

# Run-specific temporary inventory
var run_inventory: Dictionary = {
	"temp_cards": [],
	"temp_coins": 0,
	"is_on_run": false
}

signal health_changed(new_health: int)
signal nerve_changed(new_nerve: int)
signal coins_changed(new_coins: int)
signal loot_coins_changed(new_coins: int)
signal cards_changed()
signal deck_changed()

func _ready() -> void:
	# Initialize with starting cards
	#initialize_starting_deck()
	pass

# Initialize the player's starting deck
func initialize_starting_deck() -> void:
	# Load the 8 basic starting cards
	var basic_card_paths = [
		"res://Assets/Resources/cards/basic_attack_1.tres",
		"res://Assets/Resources/cards/basic_attack_2.tres",
		"res://Assets/Resources/cards/basic_defense_1.tres",
		"res://Assets/Resources/cards/basic_defense_2.tres",
		"res://Assets/Resources/cards/basic_move_1.tres",
		"res://Assets/Resources/cards/basic_move_2.tres",
		"res://Assets/Resources/cards/basic_heal_1.tres",
		"res://Assets/Resources/cards/basic_heal_2.tres"
	]
	
	for path in basic_card_paths:
		if ResourceLoader.exists(path):
			var card = load(path)
			if card:
				owned_cards.append(card)
				if current_deck.size() < max_deck_size:
					current_deck.append(card)

# Health Management
func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health)

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health)

func set_max_health(new_max: int) -> void:
	max_health = new_max
	current_health = min(current_health, max_health)
	health_changed.emit(current_health)

# Nerve Management
func take_nerve_damage(amount: int) -> void:
	print('taking '+str(amount)+' nerve damage')
	current_nerve = max(0, current_nerve - amount)
	nerve_changed.emit(current_nerve)

func heal_nerve(amount: int) -> void:
	current_nerve = min(max_nerve, current_nerve + amount)
	nerve_changed.emit(current_nerve)

func set_max_nerve(new_max: int) -> void:
	max_nerve = new_max
	current_nerve = min(current_nerve, max_nerve)
	nerve_changed.emit(current_nerve)


func use_flask() -> bool:
	if healing_flasks > 0:
		healing_flasks -= 1
		heal(flask_heal_amount)
		return true
	return false

# Coin Management
func add_coins(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)

func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
		return true
	return false
	
func loot_coins(amount: int) -> void:
	coins_looted += amount
	loot_coins_changed.emit(coins_looted)
	
func transfer_loot_coins():
	coins += coins_looted
	coins_looted = 0
	coins_changed.emit(coins)

# Card Management
func add_card_to_collection(card_resource: Resource) -> void:
	owned_cards.append(card_resource)
	cards_changed.emit()

func add_card_to_deck(card_resource: Resource) -> bool:
	if current_deck.size() < max_deck_size and card_resource in owned_cards:
		current_deck.append(card_resource)
		deck_changed.emit()
		return true
	return false

func remove_card_from_deck(card_resource: Resource) -> bool:
	var index = current_deck.find(card_resource)
	if index != -1:
		current_deck.remove_at(index)
		deck_changed.emit()
		return true
	return false

func get_random_hand(hand_size: int = 4) -> Array[Resource]:
	var hand: Array[Resource] = []
	var available_cards = current_deck.duplicate()
	available_cards.shuffle()
	
	for i in range(min(hand_size, available_cards.size())):
		hand.append(available_cards[i])
	
	return hand

# Run Management
func start_run() -> void:
	run_inventory.is_on_run = true
	run_inventory.temp_cards.clear()
	run_inventory.temp_coins = 0
	# Reset health and flasks for the run
	current_health = max_health
	healing_flasks = max_flasks

func add_temp_card(card_resource: Resource) -> void:
	if run_inventory.is_on_run:
		run_inventory.temp_cards.append(card_resource)

func add_temp_coins(amount: int) -> void:
	if run_inventory.is_on_run:
		run_inventory.temp_coins += amount

func end_run_success() -> void:
	# Transfer temporary items to permanent inventory
	for card in run_inventory.temp_cards:
		add_card_to_collection(card)
	
	add_coins(run_inventory.temp_coins)
	
	# Clear run inventory
	run_inventory.is_on_run = false
	run_inventory.temp_cards.clear()
	run_inventory.temp_coins = 0

func end_run_failure() -> void:
	# Lose all temporary items
	run_inventory.is_on_run = false
	run_inventory.temp_cards.clear()
	run_inventory.temp_coins = 0

# Shop Functions
func upgrade_flask_healing(cost: int, heal_increase: int) -> bool:
	if spend_coins(cost):
		flask_heal_amount += heal_increase
		return true
	return false

func buy_card(card_resource: Resource, cost: int) -> bool:
	if spend_coins(cost):
		add_card_to_collection(card_resource)
		return true
	return false

# Save/Load Functions
func save_inventory() -> Dictionary:
	var save_data = {
		"current_health": current_health,
		"max_health": max_health,
		"coins": coins,
		"healing_flasks": healing_flasks,
		"max_flasks": max_flasks,
		"flask_heal_amount": flask_heal_amount,
		"owned_cards": [],
		"current_deck": []
	}
	
	# Save card resource paths
	for card in owned_cards:
		save_data.owned_cards.append(card.resource_path)
	
	for card in current_deck:
		save_data.current_deck.append(card.resource_path)
	
	return save_data

func load_inventory(save_data: Dictionary) -> void:
	current_health = save_data.get("current_health", 10)
	max_health = save_data.get("max_health", 10)
	coins = save_data.get("coins", 0)
	healing_flasks = save_data.get("healing_flasks", 3)
	max_flasks = save_data.get("max_flasks", 3)
	flask_heal_amount = save_data.get("flask_heal_amount", 5)
	
	# Load cards from paths
	owned_cards.clear()
	for path in save_data.get("owned_cards", []):
		if ResourceLoader.exists(path):
			var card = load(path)
			if card:
				owned_cards.append(card)
	
	current_deck.clear()
	for path in save_data.get("current_deck", []):
		if ResourceLoader.exists(path):
			var card = load(path)
			if card:
				current_deck.append(card)
	
	# Emit signals to update UI
	health_changed.emit(current_health, max_health)
	coins_changed.emit(coins)
	cards_changed.emit()
	deck_changed.emit()
