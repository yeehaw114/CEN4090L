extends Panel

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var area_texure: TextureRect = $VBoxContainer/AreaTexure
@onready var area_info_text: RichTextLabel = $VBoxContainer/AreaInfoText
@onready var enter_button: Button = $VBoxContainer/EnterButton

var Area_scene : PackedScene

func set_values(scene: PackedScene,title: String,texture:Texture2D,info:String):
	Area_scene = scene
	title_label.text = title
	area_texure.texture = texture
	area_info_text.text = info

func _on_enter_button_pressed() -> void:
	get_tree().change_scene_to_packed(Area_scene)
