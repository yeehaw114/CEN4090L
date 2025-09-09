extends Node2D
class_name Card

@export var card_stats: CardResource

@export var card_name: String
@export var card_description: String
@export var card_cost: int

@onready var cost_label: Label = $BaseCardSprite/CostLabel
@onready var description_label: Label = $BaseCardSprite/DescriptionLabel

func set_values() -> void:
	cost_label.text = str(card_cost)
	description_label.text = card_description
	


func mouse_entered_card_area() -> void:
	print('mouse over card '+ card_name)
