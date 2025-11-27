extends Panel

@onready var melee_texture: TextureRect = $MeleeTexture
@onready var gear_description_popup: Panel = $GearDescriptionPopup

var resource : WeaponResource

func _ready() -> void:
	resource = PlayerInventory.weapon_resource
	set_weapon(resource)
	gear_description_popup.set_values(resource)

func set_weapon(res: WeaponResource):
	melee_texture.texture = res.texture

func _on_mouse_entered() -> void:
	gear_description_popup.show()

func _on_mouse_exited() -> void:
	gear_description_popup.hide()
