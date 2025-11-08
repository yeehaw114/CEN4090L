extends Node2D

@onready var shop_ui: Control = $CanvasLayer/ShopUI
@onready var coin_label: Label = $CanvasLayer/CoinContainer/CoinLabel
@onready var coin_container: Panel = $CanvasLayer/CoinContainer

func _ready() -> void:
	GlobalAudioStreamPlayer.play_lobby_music()
	coin_label.text = str(GameState.coins)+" Coins"

func _on_shop_trigger_body_entered(body: Node2D) -> void:
	print("Triggered by: ", body.name)
	if body.name == "Player":
		shop_ui.visible = true 

func _on_shop_trigger_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		shop_ui.visible = false 

func update_coin_label():
	coin_label.text = str(GameState.coins)+" Coins"

func set_coin_label_visibility(toggle: bool):
	if toggle:
		coin_container.show()
	else:
		coin_container.hide()
	
