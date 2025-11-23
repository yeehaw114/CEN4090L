extends TextureButton

@export var scene : PackedScene
@export var title : String
@export var texture : Texture2D
@export_multiline var info : String

signal area_selected(scene,title,texture,info)

func _ready():
	print("My scene is:", scene)

func _on_pressed() -> void:
	area_selected.emit(scene,title,texture,info)
