extends Resource
class_name Action

enum ACTION_TYPE {DAMAGE, HEAL, BUFF, DEBUFF, BLOCK}
enum POWER {LIGHT,MEDIUM,HEAVY}

@export var value: int
@export var type: ACTION_TYPE
@export var power: POWER = POWER.LIGHT
@export var status_effect: StatusEffect
@export var status_effect_value: int
@export var apply_to_self := false

func to_dict():
	return {
		"value": value,
		"type": type,
	}
