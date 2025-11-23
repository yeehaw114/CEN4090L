extends Panel

@onready var weapon_texture: TextureRect = $WeaponTexture

@export var resource : WeaponResource

func _ready() -> void:
	set_weapon(resource)

func set_weapon(res: WeaponResource):
	weapon_texture.texture = res.texture
