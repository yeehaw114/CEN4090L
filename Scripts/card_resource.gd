extends Resource
class_name CardResource

#VISUAL DATA
@export_category('visual stats')
@export var card_name: String
@export var card_cost: int
@export var card_description: String
@export var card_image: Texture2D

#COMBAT DATA
@export_category('combat data')
@export var card_actions: Array[Action]
