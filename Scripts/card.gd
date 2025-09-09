extends Node2D
class_name Card

@export var card_stats: CardResource

@export var card_name: String
@export var card_description: String
@export var card_cost: int

@onready var cost_label: Label = $BaseCardSprite/CostLabel
@onready var description_label: Label = $BaseCardSprite/DescriptionLabel

var is_currently_selected: bool = false

func set_values() -> void:
	cost_label.text = str(card_cost)
	description_label.text = card_description
	
func _ready() -> void:
	set_values()

func mouse_entered_card_area() -> void:
	if is_currently_selected:
		return
	scale = scale + Vector2(1,1)

func mouse_exited_card_area() -> void:
	if is_currently_selected:
		return
	scale = scale - Vector2(1,1)
