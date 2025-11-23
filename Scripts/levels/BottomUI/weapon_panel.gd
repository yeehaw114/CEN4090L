extends Panel

@onready var weapon_texture: TextureRect = $WeaponTexture
@onready var gear_description_popup: Panel = $GearDescriptionPopup

@export var resource : WeaponResource

func _ready() -> void:
	set_weapon(resource)
	var name = resource.weapon_name
	var damage_min = resource.damage_min
	var damage_max = resource.damage_max
	
	gear_description_popup.set_values(name,damage_min,damage_max)

func set_weapon(res: WeaponResource):
	weapon_texture.texture = res.texture


func _on_mouse_entered() -> void:
	gear_description_popup.show()


func _on_mouse_exited() -> void:
	gear_description_popup.hide()
