extends TextureButton

@export var scene : PackedScene
@export var title : String
@export var texture : Texture2D
@export_multiline var info : String
@export var weapon_reward : WeaponResource

signal area_selected(scene,title,texture,info)
signal reward_display(weapon: WeaponResource)

func _ready():
	print("My scene is:", scene)

func _on_pressed() -> void:
	area_selected.emit(scene,title,texture,info)
	if weapon_reward:
		reward_display.emit(weapon_reward)
