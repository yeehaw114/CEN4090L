extends Control

@onready var card_container: HBoxContainer = $Panel/VBoxContainer/VBoxContainer/CardContainer
@onready var coin_reward_label: Label = $Panel/VBoxContainer/CoinRewardLabel

var coins_value: int
var card_resources: Array[CardResource]

func _on_button_pressed() -> void:
	print('ATTEMPT TO RETURN TO: '+str(GameState.previous_scene))
	GameState.return_to_previous_scene_live()

func set_reward_values(coins:int,cards:Array[CardResource]):
	coin_reward_label.text = 'Coins Earned: '+str(coins)
	for card in card_container.get_children():
		var index := 0
		card.card_stats = cards[index]
		card.set_values()
		index += 1
