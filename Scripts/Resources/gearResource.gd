extends InvItem
class_name GearResource

enum WEIGHT {LIGHT,MEDIUM,HEAVY}
enum RARITY {COMMON,UNCOMMON,RARE,MASTER}

@export var weight : WEIGHT = WEIGHT.LIGHT
@export var rarity : RARITY = RARITY.COMMON
@export var mass : int
