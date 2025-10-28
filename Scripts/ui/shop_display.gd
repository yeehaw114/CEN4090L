extends Control

@onready var card_left: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Card
@onready var card_middle: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/Card
@onready var card_right: Card = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/Card

@onready var left_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/LeftCostLabel
@onready var middle_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/MiddleCostLabel
@onready var right_cost_label: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/RightCostLabel

@onready var purchase_button_left: Button = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/PurchaseButton
@onready var purchase_button_middle: Button = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/PurchaseButton
@onready var purchase_button_right: Button = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/PurchaseButton

@onready var sold_out_label_left: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/SoldOutLabel
@onready var sold_out_label_middle: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer2/VBoxContainer/SoldOutLabel
@onready var sold_out_label_right: Label = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/PanelContainer3/VBoxContainer/SoldOutLabel

@onready var coin_value_label: Label = $PanelContainer2/VBoxContainer/CoinValueLabel

var card_file_path := "res://Assets/Resources/cards/final_cards/"

var card_resources : Array[CardResource] = []
signal toggle_display(toggle: bool)
signal new_card_unlocked

func _ready() -> void:
	card_resources = CardCollection.get_all_locked_cards()
	update_cards(card_resources)
	coin_value_label.text = str(GameState.coins)
	set_coin_values()
	
func set_coin_values():
	if card_left.card_stats:
		left_cost_label.text = str(card_left.card_stats.cost)+' Coins'
	if card_middle.card_stats:
		middle_cost_label.text = str(card_middle.card_stats.cost)+' Coins'
	if card_right.card_stats:
		right_cost_label.text = str(card_right.card_stats.cost)+' Coins'
	
func spend_coins(value: int):
	var current_coins = GameState.coins
	var final_coins = current_coins - value
	if final_coins < 0:
		final_coins = 0
	coin_value_label.text = str(final_coins)
	GameState.coins = final_coins

func update_card_resources(cards : Array[CardResource]):
	card_resources = cards

func update_cards(card_resources : Array[CardResource]):
	card_resources.shuffle()

	var card_nodes = [card_left, card_middle, card_right]
	var label_nodes = [left_cost_label,middle_cost_label,right_cost_label]
	var purchase_buttons = [purchase_button_left,purchase_button_middle,purchase_button_right]
	var sold_labels = [sold_out_label_left,sold_out_label_middle,sold_out_label_right]

	for i in range(card_nodes.size()):
		if i < card_resources.size():
			card_nodes[i].card_stats = card_resources[i]
			card_nodes[i].set_values()
			show_panel(i)
		else:
			hide_panel(i)

func show_panel(index: int):
	if index == 0:
		card_left.show()
		left_cost_label.show()
		purchase_button_left.show()
		sold_out_label_left.hide()
	elif index == 1:
		card_middle.show()
		middle_cost_label.show()
		purchase_button_middle.show()
		sold_out_label_middle.hide()
	elif  index == 2:
		card_right.show()
		right_cost_label.show()
		purchase_button_right.show()
		sold_out_label_right.hide()
		
func hide_panel(index: int):
	if index == 0:
		card_left.hide()
		left_cost_label.hide()
		purchase_button_left.hide()
		sold_out_label_left.show()
	elif index == 1:
		card_middle.hide()
		middle_cost_label.hide()
		purchase_button_middle.hide()
		sold_out_label_middle.show()
	elif  index == 2:
		card_right.hide()
		right_cost_label.hide()
		purchase_button_right.hide()
		sold_out_label_right.show()

func left_purchase():
	if GameState.coins >= card_left.card_stats.cost:
		hide_panel(0)
		CardCollection.set_card_to_unlocked(card_left.card_stats)
		new_card_unlocked.emit()
		spend_coins(card_left.card_stats.cost)
	
func middle_purchase():
	if GameState.coins >= card_middle.card_stats.cost:
		hide_panel(1)
		CardCollection.set_card_to_unlocked(card_middle.card_stats)
		new_card_unlocked.emit()
		spend_coins(card_middle.card_stats.cost)
	
func right_purchase():
	if GameState.coins >= card_right.card_stats.cost:
		hide_panel(2)
		CardCollection.set_card_to_unlocked(card_right.card_stats)
		new_card_unlocked.emit()
		spend_coins(card_right.card_stats.cost)

func _on_exit_button_pressed() -> void:
	hide()
	toggle_display.emit(true)

func _on_shop_object_interacted_with() -> void:
	show()
	toggle_display.emit(false)
