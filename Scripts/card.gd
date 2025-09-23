extends Node2D
class_name Card

const SIZE := Vector2(32,48)

@export var card_stats: CardResource

@onready var cost_label: Label = $BaseCardSprite/CostLabel
@onready var description_label: Label = $BaseCardSprite/DescriptionLabel

var is_currently_selected: bool = false

func set_values() -> void:
	cost_label.text = str(card_stats.card_cost)
	description_label.text = card_stats.card_description
	
func _ready() -> void:
	set_values()

func mouse_entered_card_area() -> void:
	if is_currently_selected:
		return
	increase_scale(1)

func mouse_exited_card_area() -> void:
	if is_currently_selected:
		return
	decrease_scale(1)

func increase_scale(n: int):
	#scale = scale + Vector2(n,n)
	pass
	
func decrease_scale(n: int):
	#scale = scale - Vector2(n,n)
	pass
	
func reset_scale_and_position():
	#scale = Vector2(2,2)
	#position.y = 450
	pass
