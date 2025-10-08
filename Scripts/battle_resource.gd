extends Resource
class_name BattleResource

enum rank {ONE=1,TWO=2,THREE=3,FOUR=4}

@export var starting_cards : Array[CardResource]
@export var enemy_rank_1 : EnemyResource
@export var enemy_rank_2 : EnemyResource
@export var enemy_rank_3 : EnemyResource
@export var enemy_rank_4 : EnemyResource

@export var player_position : rank
