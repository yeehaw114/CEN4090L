extends PanelContainer

@onready var level_progress_bar: ProgressBar = $VBoxContainer/LevelProgressBar
@onready var time_progression_label: Label = $VBoxContainer/TimeProgressionLabel

func set_progress(progress: float):
	level_progress_bar.value = progress

func set_time_progress(hours: int):
	time_progression_label.text = 'Hours passed: '+str(hours)
