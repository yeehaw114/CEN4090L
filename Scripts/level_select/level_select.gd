extends Control

@onready var area_info: Panel = $AreaInfo

func _ready() -> void:
	area_info.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Cancel"):
		if area_info.visible:
			area_info.hide()

func area_selected(scene: Variant, title: Variant, texture: Variant, info: Variant, is_home: Variant) -> void:
	area_info.set_values(scene,title,texture,info)
	area_info.is_home = is_home
	area_info.show()

func _on_reward_display(weapon: WeaponResource) -> void:
	area_info.set_reward(weapon)
