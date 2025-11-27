extends HBoxContainer

@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	PlayerInventory.coins_changed.connect(update_money)
	money_label.text = str(PlayerInventory.coins)

func update_money(money:int):
	money_label.text = str(money)
