extends Control

@onready var storage_entrance: Area2D = $StorageEntrance
@onready var church_entrance: Area2D = $ChurchEntrance
@onready var infirmary_entrance: Area2D = $InfirmaryEntrance
@onready var townhall_entrance: Area2D = $TownhallEntrance
@onready var field_entrance: Area2D = $FieldEntrance
@onready var smithy_entrance: Area2D = $SmithyEntrance

func check_if_mouse_over_entrance():
	for entrance in get_children():
		if entrance.is_mouse_over:
			print(entrance)
			return entrance
