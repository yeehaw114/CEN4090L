extends Panel

@onready var level_label: Label = $VBoxContainer/LevelContainer/LevelLabel
@onready var accuracy_label: Label = $VBoxContainer/AccuracyContainer/AccuracyLabel
@onready var dodge_label: Label = $VBoxContainer/DodgeContainer/DodgeLabel
@onready var crit_label: Label = $VBoxContainer/CritContainer/CritLabel
@onready var money_label: Label = $VBoxContainer/MoneyContainer/MoneyLabel

func _ready() -> void:
	update_accuracy_label(PlayerInventory.accuracy)
	PlayerInventory.loot_coins_changed.connect(update_money_label)

func update_money_label(money: int):
	money_label.text = str(money)

func update_accuracy_label(amount:int):
	accuracy_label.text = str(amount)
