extends Resource
class_name InvItem

enum STAT {HEALTH,NERVE}

@export var name: String = ""
@export var texture: Texture2D

@export_category("effect")
@export var stat: STAT
@export var value: int = 0 
