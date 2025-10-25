extends Resource
class_name BattleResource

enum rank {ONE=1,TWO=2,THREE=3,FOUR=4}
@export_category('Cards')
@export var starting_cards : Array[CardResource]

@export_category('Position')
@export var enemy_rank_1 : EnemyResource
@export var enemy_rank_2 : EnemyResource
@export var enemy_rank_3 : EnemyResource
@export var enemy_rank_4 : EnemyResource
@export var player_position : rank

@export_category('Rewards')
@export var coins_min : int
@export var coins_max : int
@export var cards : Array[CardResource]
