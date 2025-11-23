extends Panel

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var damage_range_label: Label = $MarginContainer/VBoxContainer/DamageRangeLabel

const OFFSET := Vector2(-300,-200)

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	position = get_global_mouse_position() + OFFSET

func set_values(name:String,damage_min:int,damage_max:int):
	name_label.text = name
	damage_range_label.text = 'DAMAGE: '+str(damage_min)+' - '+str(damage_max)
