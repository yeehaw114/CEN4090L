extends PanelContainer

@onready var rich_text_label: RichTextLabel = $RichTextLabel

const OFFSET := Vector2(10,10)
var opacity_tween : Tween = null

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET

func toggle(on: bool):
	if on:
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
		print('TOOLTIP TOGGLE ON')
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()
		print('TOOLTIP TOGGLE OFF')

func tween_opacity(to: float):
	if opacity_tween:
		opacity_tween.kill()
	
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, 0.3)
	return opacity_tween

func set_text(text: String):
	rich_text_label.text = text
