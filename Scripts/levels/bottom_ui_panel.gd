extends Panel

@onready var health_bar: ProgressBar = $HBoxContainer/VBoxContainer/HealthBar
@onready var nerve_bar: ProgressBar = $HBoxContainer/VBoxContainer/NerveBar
@onready var player_portrait: TextureRect = $HBoxContainer/PlayerPortrait
@onready var inventory_level: Control = $HBoxContainer/InventoryLevel

const normal_portrait = preload("res://Assets/Textures/player_portrait.png")
const portrait_stage_1 = preload("res://Assets/Textures/player_portrait_stage_1.png")
const portrait_stage_2 = preload("res://Assets/Textures/player_portrait_stage_2.png")

func _ready() -> void:
	nerve_bar.max_value = PlayerInventory.max_nerve
	nerve_bar.value = PlayerInventory.current_nerve
	health_bar.max_value = PlayerInventory.max_health
	health_bar.value = PlayerInventory.current_health
	PlayerInventory.health_changed.connect(update_health)
	PlayerInventory.nerve_changed.connect(update_nerve)

func update_health(value: int):
	health_bar.value = value

func update_nerve(value: int):
	nerve_bar.value = value
	update_portrait(value)

func update_portrait(nerve: int):
	if nerve > 50:
		player_portrait.texture = normal_portrait
	elif nerve > 25:
		player_portrait.texture = portrait_stage_1
	else:
		player_portrait.texture = portrait_stage_2
