extends GearResource
class_name ArmourResource

enum DEFENSE {FATAL,WEAK,NORMAL,STRONG}

@export var block_min : int
@export var block_max : int

@export var melee_defense_health : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_health : DEFENSE = DEFENSE.NORMAL
@export var melee_defense_nerve : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_nerve : DEFENSE = DEFENSE.NORMAL
