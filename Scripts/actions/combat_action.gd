extends Node
class_name Action

enum ACTION_TYPE {DAMAGE, HEAL}

var sender: Character
var recipient: Character
var value
var type
var status_effect
var status_effect_value

func _init(_sender, _recipient, _value, _type, status_effect=null,status_effect_value=null) -> void:
	sender = _sender
	recipient = _recipient
	value = _value
	if _type == 'heal':
		type = ACTION_TYPE.HEAL
	else:
		type = ACTION_TYPE.DAMAGE 
