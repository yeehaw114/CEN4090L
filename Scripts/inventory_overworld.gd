extends Panel

@onready var health_bar: ProgressBar = $VBoxContainer/HBoxContainer/HealthBar
@onready var health_bar_label: Label = $VBoxContainer/HBoxContainer/HealthBar/HealthBarLabel
@onready var coins_label: Label = $VBoxContainer/CoinsLabel
@onready var card_container: GridContainer = $VBoxContainer/ScrollContainer/CardContainer

const card_scene := preload("res://Scenes/card.tscn")

signal pause_game(toggle:bool)

func _ready() -> void:
	populate_grid(GameState.transferred_cards)
	set_health_bar(GameState.current_health)
	set_coins(GameState.coins_current)
	
	GameState.cards_changed.connect(populate_grid)
	GameState.coins_changed.connect(set_coins)
	GameState.health_changed.connect(set_health_bar)

func populate_grid(cards: Array[CardResource]):
	clear_grid()
	print('DISPLAY DISCARD DECK\n'+str(cards))
	for card_stat in cards:
		var new_card = card_scene.instantiate()
		new_card.card_stats = card_stat
		new_card.is_able_to_be_selected = false
		card_container.add_child(new_card)
	print()
	
func clear_grid():
	for card in card_container.get_children():
		card.queue_free()

func set_health_bar(value: int):
	health_bar.max_value = GameState.max_health
	health_bar.value = value
	health_bar_label.text = str(value)+'/'+str(GameState.max_health)

func set_coins(coins:int):
	coins_label.text = 'Coins: '+str(coins)


func _on_exit_button_pressed() -> void:
	pause_game.emit(false)
