extends Resource
class_name Action

enum ACTION_TYPE {DAMAGE, HEAL, BUFF, DEBUFF, BLOCK}

@export var value: int
@export var type: ACTION_TYPE
@export var status_effect: StatusEffect
@export var status_effect_value: int

func to_dict():
	return {
		"value": value,
		"type": type,
	}
