extends Control

@onready var card_container: HBoxContainer = $Panel/VBoxContainer/VBoxContainer/CardContainer
@onready var coin_reward_label: Label = $Panel/VBoxContainer/CoinRewardLabel
@onready var continue_button: Button = $Panel/ContinueButton
@onready var select_card_label: Label = $Panel/VBoxContainer/VBoxContainer/SelectCardLabel
@onready var none_button: Button = $Panel/VBoxContainer/VBoxContainer/NoneButton

var coins_value: int
var card_resources: Array[CardResource]

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
