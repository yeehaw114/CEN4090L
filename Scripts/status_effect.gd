extends Control

@export var status_effect_resource : StatusEffect

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var tool_tip: PanelContainer = $ToolTip


func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	tool_tip.set_text(status_effect_resource.tooltip_text)

func _process(_delta):
	queue_redraw()

func set_data():
	if status_effect_resource:
		texture_rect.texture = status_effect_resource.texture
		label.text = str(status_effect_resource.count)

func on_mouse_entered():
	tool_tip.toggle(true)
	print('TOOLTIP TOGGLE ON')
func on_mouse_exited():
	tool_tip.toggle(false)
	print('TOOLTIP TOGGLE OFF')

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), Color(1, 0, 0, 0.3), false) # outline
