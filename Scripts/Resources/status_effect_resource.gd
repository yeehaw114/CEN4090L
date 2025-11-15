extends Resource
class_name StatusEffect

enum type {BUFF,DEBUFF,DOT}
enum stat {NONE,DAMAGE,BLOCK,CRIT}

@export var name : String
@export var _type : type
@export var value : int
@export var _stat : stat
var count : int = 0

@export var texture : Texture2D
@export_multiline var tooltip_text : String
