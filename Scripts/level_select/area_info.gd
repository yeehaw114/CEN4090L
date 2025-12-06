extends Panel

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var area_texure: TextureRect = $VBoxContainer/AreaTexure
@onready var area_info_text: RichTextLabel = $VBoxContainer/AreaInfoText
@onready var enter_button: Button = $VBoxContainer/EnterButton
@onready var reward_label: Label = $VBoxContainer/RewardLabel
@onready var weapon_slot: Panel = $VBoxContainer/WeaponSlot

const provision_scene := preload("res://Scenes/provision_screen.tscn")

var Area_scene : PackedScene
var is_home := false

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
	reward_slot.item = weapon
	weapon_slot.update(reward_slot)

func _on_enter_button_pressed() -> void:
	if weapon_slot.slotData:
		LevelManager.reward = weapon_slot.slotData.item
	LevelManager.current_scene = Area_scene
	if is_home:
		get_tree().change_scene_to_file("res://Scenes/town.tscn")
		return
	get_tree().change_scene_to_packed(provision_scene)
