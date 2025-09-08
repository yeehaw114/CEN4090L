extends Control

@onready var attack_button: Button = $AttackButton
@onready var skill_button: Button = $SkillButton
@onready var items_button: Button = $ItemsButton

func _ready() -> void:
	attack_button.grab_focus()
