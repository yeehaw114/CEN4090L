extends Resource
class_name CardResource

enum rank {ONE=1,TWO=2,THREE=3,FOUR=4}

@export var is_unlocked_at_start : bool = false
@export var is_locked : bool = true
@export var cost : int = 0
#VISUAL DATA
@export_category('visual stats')
@export var card_name: String
@export var card_cost: int
@export var card_description: String
@export var card_image: Texture2D

#COMBAT DATA
@export_category('combat data')
@export var card_actions: Array[Action]

@export_category('rank data')
@export var character_position : Array[rank]
@export var enemy_position : Array[rank]

func to_dict():
	return {
		"card_name": card_name,
		"is_locked": is_locked,
	}

func from_dict(data: Dictionary):
	is_locked = data.get("is_locked", false)
