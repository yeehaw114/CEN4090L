extends TextureButton

@export var scene : PackedScene

func _ready():
	print("My scene is:", scene)

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
