extends Node2D

@onready var shop_ui: Control = $CanvasLayer/ShopUI

func _on_shop_trigger_body_entered(body: Node2D) -> void:
	print("Triggered by: ", body.name)
	if body.name == "Player":
		shop_ui.visible = true 


func _on_shop_trigger_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		shop_ui.visible = false 


func _on_save_test_pressed() -> void:
	print('ATTEMPT TO SAVE GAME')
	GameState.save()
