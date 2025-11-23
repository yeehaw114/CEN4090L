extends Control

@onready var area_info: Panel = $AreaInfo

func _ready() -> void:
	area_info.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Cancel"):
		if area_info.visible:
			area_info.hide()

func area_selected(scene: Variant, title: Variant, texture: Variant, info: Variant) -> void:
	area_info.set_values(scene,title,texture,info)
	area_info.show()
