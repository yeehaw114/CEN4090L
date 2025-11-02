extends Panel

@onready var room_name_label: Label = $MarginContainer/VBoxContainer/RoomNameLabel
@onready var danger_label_value: Label = $MarginContainer/VBoxContainer/DangerLabelValue

func set_values(room_name: String, danger: String):
	room_name_label.text = room_name
	danger_label_value.text = danger
	
