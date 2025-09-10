extends Resource
class_name Action

enum ACTION_TYPE {DAMAGE, HEAL}
enum STATUS_EFFECT {}

@export var value: int
@export var type: ACTION_TYPE
@export var status_effect: STATUS_EFFECT
@export var status_effect_value: int
