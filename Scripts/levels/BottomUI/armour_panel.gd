extends Panel

@onready var armour_texture: TextureRect = $ArmourTexture
@onready var gear_description_popup: Panel = $GearDescriptionPopup

var resource : ArmourResource

func _ready() -> void:
	resource = PlayerInventory.armour_resource
	set_armour(resource)
	gear_description_popup.set_values(resource)

func set_armour(res: ArmourResource):
	armour_texture.texture = res.texture

func _on_mouse_entered() -> void:
	gear_description_popup.show()

func _on_mouse_exited() -> void:
	gear_description_popup.hide()
