extends Node2D



func _on_shop_trigger_body_entered(body: Node2D) -> void:
	print("Triggered by: ", body.name)
	if body.name == "Player":
		$ShopUI.visible = true # Replace with function body.


func _on_shop_trigger_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$ShopUI.visible = false # Replace with function body.
