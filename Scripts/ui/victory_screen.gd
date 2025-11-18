extends Control

@onready var card_container: HBoxContainer = $VictoryPanel/VBoxContainer/VBoxContainer/CardContainer
@onready var coin_reward_label: Label = $VictoryPanel/VBoxContainer/CoinRewardLabel
@onready var continue_button: Button = $VictoryPanel/ContinueButton
@onready var select_card_label: Label = $VictoryPanel/VBoxContainer/VBoxContainer/SelectCardLabel
@onready var none_button: Button = $VictoryPanel/VBoxContainer/VBoxContainer/NoneButton
@onready var display_card_deck: Control = $DisplayCardDeck
@onready var view_player_cards_button: Button = $VictoryPanel/VBoxContainer/ViewPlayerCardsButton

var coins_value: int
var card_resources: Array[CardResource]

var player_hand : Array[CardResource]

func _ready() -> void:
	display_card_deck.exit_button_clicked.connect(close_display_player_cards)

func set_current_players_hand(cards: Array[CardResource]):
	display_card_deck.stats_list = cards
	display_card_deck.populate_grid()

func _on_return_button_pressed() -> void:
	if GameState.boss_time:
		GameState.coins_current += coins_value
		GameState.change_scene(GameState.SCENES['lobby'])
		return
	
	print('ATTEMPT TO RETURN TO: '+str(GameState.previous_scene))
	GameState.coins_current += coins_value
	print('COINS NEW VALUE: '+str(GameState.coins_current))
	GlobalAudioStreamPlayer.play_dungeon_music()
	GameState.return_to_previous_scene_live()

func set_reward_values(coins:int,cards:Array[CardResource]):
	
	coin_reward_label.text = "Coins Earned: " + str(coins)
	coins_value = coins
	var children := card_container.get_children()
	var index := 0
	if GameState.boss_time:
		show_continue()
		return
	for card in cards:
		children[index].show()
		children[index].card_stats = card
		children[index].set_values()
		index += 1
		print("\nREWARD CARD RESOURCES: " + str(cards))

func show_continue() -> void:
	for card in card_container.get_children():
		card.is_able_to_be_selected = false
	continue_button.show()
	card_container.hide()
	select_card_label.hide()
	none_button.hide()
	view_player_cards_button.hide()


func _on_view_player_cards_button_pressed() -> void:
	display_card_deck.show()

func close_display_player_cards():
	display_card_deck.hide()
