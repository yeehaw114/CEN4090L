extends Panel
@onready var rarity_label: Label = $MarginContainer/VBoxContainer/RarityLabel
@onready var weight_label: Label = $MarginContainer/VBoxContainer/WeightLabel
@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var value_range_label: Label = $MarginContainer/VBoxContainer/ValueRangeLabel

const OFFSET := Vector2(16,16)

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	global_position = get_global_mouse_position() + OFFSET

func set_values(resource: Resource):
	if resource is WeaponResource or resource is RangedResource:
		name_label.text = resource.weapon_name
		value_range_label.text = 'DAMAGE: '+str(resource.damage_min)+' - '+str(resource.damage_max)
	elif resource is ArmourResource:
		name_label.text = resource.armour_name
		value_range_label.text = 'BLOCK: '+str(resource.block_min)+' - '+str(resource.block_max)
	if resource.rarity == WeaponResource.RARITY.COMMON:
		rarity_label.text = 'COMMON'
	if resource.weight == WeaponResource.WEIGHT.LIGHT:
		weight_label.text = 'Light'
