extends Resource
class_name WeaponResource

enum WEIGHT {LIGHT,MEDIUM,HEAVY}
enum RARITY {COMMON,UNCOMMON,RARE,MASTER}

@export var weapon_name : String
@export var texture : Texture2D
@export var weight : WEIGHT = WEIGHT.LIGHT
@export var rarity : RARITY = RARITY.COMMON
@export var damage_min : int = 0
@export var damage_max : int = 0
