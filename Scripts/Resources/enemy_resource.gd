extends Resource
class_name EnemyResource

enum DEFENSE {FATAL,WEAK,NORMAL,STRONG}

@export var max_health : int
@export var enemy_texture : Texture2D
@export var actions : Array[Action]

@export var melee_defense_health : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_health : DEFENSE = DEFENSE.NORMAL
@export var melee_defense_nerve : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_nerve : DEFENSE = DEFENSE.NORMAL
