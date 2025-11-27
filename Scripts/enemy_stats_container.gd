extends HBoxContainer
@onready var health_bar: ProgressBar = $BarContainer/HealthContainer/HealthBar
@onready var nerve_bar: ProgressBar = $BarContainer/NerveContainer/NerveBar

func update_health(amount:int,max:int):
	health_bar.max_value = max
	health_bar.value = amount
	
func update_nerve(amount:int,max:int):
	nerve_bar.max_value = max
	nerve_bar.value = amount
