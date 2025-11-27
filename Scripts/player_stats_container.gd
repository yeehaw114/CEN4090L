extends HBoxContainer

@onready var health_bar: ProgressBar = $BarContainer/HealthContainer/HealthBar
@onready var nerve_bar: ProgressBar = $BarContainer/NerveContainer/NerveBar

func _ready() -> void:
	health_bar.max_value = PlayerInventory.max_health
	health_bar.value = PlayerInventory.current_health
	nerve_bar.max_value = PlayerInventory.max_nerve
	nerve_bar.value = PlayerInventory.current_nerve
	PlayerInventory.health_changed.connect(update_health)
	PlayerInventory.nerve_changed.connect(update_nerve)
	
func update_health(amount:int):
	health_bar.value = amount
	
func update_nerve(amount:int):
	nerve_bar.value = amount
