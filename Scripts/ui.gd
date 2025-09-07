extends Control

@onready var attack_button: Button = $AttackButton
@onready var skill_button: Button = $SkillButton
@onready var items_button: Button = $ItemsButton

func _ready() -> void:
	attack_button.grab_focus()

func _on_attack_button_pressed() -> void:
	print('pressed attack button')


func _on_skill_button_pressed() -> void:
	print('pressed skill button')


func _on_items_button_pressed() -> void:
	print('pressed items button')
