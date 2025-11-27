extends Panel
@onready var loot_inventory: InventoryLevel = $ScrollContainer/VBoxContainer/LootInventory
@onready var weapon_inventory: Control = $ScrollContainer/VBoxContainer/WeaponInventory
@onready var money_label: Label = $ScrollContainer/VBoxContainer/MoneyLabel

func set_money_label(money_collected: int):
	money_label.text = 'Money Looted: '+str(money_collected)

func set_loot_inventory(inv: Inv):
	loot_inventory.set_inventory(inv)

func _on_exit_button_pressed() -> void:
	PlayerInventory.transfer_loot_coins()
	print('coins now: '+str(PlayerInventory.coins))
	get_tree().change_scene_to_file("res://Scenes/town.tscn")
