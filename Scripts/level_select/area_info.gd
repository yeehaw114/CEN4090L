extends Panel

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var area_texure: TextureRect = $VBoxContainer/AreaTexure
@onready var area_info_text: RichTextLabel = $VBoxContainer/AreaInfoText
@onready var enter_button: Button = $VBoxContainer/EnterButton
@onready var reward_label: Label = $VBoxContainer/RewardLabel
@onready var weapon_slot: Panel = $VBoxContainer/WeaponSlot

var Area_scene : PackedScene

func set_values(scene: PackedScene,title: String,texture:Texture2D,info:String):
	reward_label.hide()
	weapon_slot.hide()
	Area_scene = scene
	title_label.text = title
	area_texure.texture = texture
	area_info_text.text = info

func set_reward(weapon: WeaponResource):
	reward_label.show()
	weapon_slot.show()
	var reward_slot = WeaponSlot.new()
	reward_slot.weapon = weapon
	weapon_slot.update(reward_slot)

func _on_enter_button_pressed() -> void:
	get_tree().change_scene_to_packed(Area_scene)
