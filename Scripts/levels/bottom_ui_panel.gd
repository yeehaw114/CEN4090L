extends Panel

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $VBoxContainer/TopContainer/VBoxContainer/HealthContainer/HealthBar
@onready var nerve_bar: ProgressBar = $VBoxContainer/TopContainer/VBoxContainer/NerveContainer/NerveBar
@onready var player_portrait: TextureRect = $VBoxContainer/TopContainer/PlayerPortrait
@onready var inventory_level: InventoryLevel = $VBoxContainer/TopContainer/InventoryLevel

const normal_portrait = preload("res://Assets/Textures/player_portrait.png")
const portrait_stage_1 = preload("res://Assets/Textures/player_portrait_stage_1.png")
const portrait_stage_2 = preload("res://Assets/Textures/player_portrait_stage_2.png")

var is_open := false
var can_open := true

signal menu_opened(toggle: bool)

func _ready() -> void:
	nerve_bar.max_value = PlayerInventory.max_nerve
	nerve_bar.value = PlayerInventory.current_nerve
	update_portrait(PlayerInventory.current_nerve)
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


func _on_open_button_pressed() -> void:
	if not can_open:
		return
	
	if is_open:
		animation_player.play("Panel_slide_down")
		is_open = false
		menu_opened.emit(false)
	else:
		is_open = true
		animation_player.play("Panel_slide_up")
		menu_opened.emit(true)
