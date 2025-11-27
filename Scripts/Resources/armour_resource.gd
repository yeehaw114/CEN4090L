extends Resource
class_name ArmourResource

enum WEIGHT {LIGHT,MEDIUM,HEAVY}
enum RARITY {COMMON,UNCOMMON,RARE,MASTER}
enum DEFENSE {FATAL,WEAK,NORMAL,STRONG}

@export var armour_name : String
@export var texture : Texture2D
@export var weight : WEIGHT = WEIGHT.LIGHT
@export var rarity : RARITY = RARITY.COMMON

@export var block_min : int
@export var block_max : int

@export var melee_defense_health : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_health : DEFENSE = DEFENSE.NORMAL
@export var melee_defense_nerve : DEFENSE = DEFENSE.NORMAL
@export var ranged_defense_nerve : DEFENSE = DEFENSE.NORMAL
