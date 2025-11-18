extends PanelContainer

@onready var level_progress_bar: ProgressBar = $LevelProgressBar

func set_progress(progress: float):
	level_progress_bar.value = progress
