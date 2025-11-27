extends VBoxContainer

@onready var nerve_defense_texture: TextureRect = $MeleeDefensesContainer/NerveDefenseTexture
@onready var health_defense_texture: TextureRect = $MeleeDefensesContainer/HealthDefenseTexture
@onready var ranged_nerve_defense_texture: TextureRect = $RangedDefensesContainer/NerveDefenseTexture
@onready var ranged_health_defense_texture: TextureRect = $RangedDefensesContainer/HealthDefenseTexture

const strong_health_region := Rect2(0,32,32,32)
const normal_health_region := Rect2(32,32,32,32)
const weak_health_region := Rect2(64,32,32,32)
const fatal_health_region := Rect2(96,32,32,32)

const strong_nerve_region := Rect2(0,0,32,32)
const normal_nerve_region := Rect2(32,0,32,32)
const weak_nerve_region := Rect2(64,0,32,32)
const fatal_nerve_region := Rect2(96,0,32,32)

func set_defenses(resource: ArmourResource):
	if resource.melee_defense_health == EnemyResource.DEFENSE.STRONG:
		health_defense_texture.texture.region = strong_health_region
	elif resource.melee_defense_health == EnemyResource.DEFENSE.NORMAL:
		health_defense_texture.texture.region = normal_health_region
	elif resource.melee_defense_health == EnemyResource.DEFENSE.WEAK:
		health_defense_texture.texture.region = weak_health_region
	elif resource.melee_defense_health == EnemyResource.DEFENSE.FATAL:
		health_defense_texture.texture.region = fatal_health_region
		
	if resource.melee_defense_nerve == EnemyResource.DEFENSE.STRONG:
		nerve_defense_texture.texture.region = strong_nerve_region
	elif resource.melee_defense_nerve == EnemyResource.DEFENSE.NORMAL:
		nerve_defense_texture.texture.region = normal_nerve_region
	elif resource.melee_defense_nerve == EnemyResource.DEFENSE.WEAK:
		nerve_defense_texture.texture.region = weak_nerve_region
	elif resource.melee_defense_nerve == EnemyResource.DEFENSE.FATAL:
		nerve_defense_texture.texture.region = fatal_nerve_region
		
	if resource.ranged_defense_health == EnemyResource.DEFENSE.STRONG:
		ranged_health_defense_texture.texture.region = strong_health_region
	elif resource.ranged_defense_health == EnemyResource.DEFENSE.NORMAL:
		ranged_health_defense_texture.texture.region = normal_health_region
	elif resource.ranged_defense_health == EnemyResource.DEFENSE.WEAK:
		ranged_health_defense_texture.texture.region = weak_health_region
	elif resource.ranged_defense_health == EnemyResource.DEFENSE.FATAL:
		ranged_health_defense_texture.texture.region = fatal_health_region
		
	if resource.ranged_defense_nerve == EnemyResource.DEFENSE.STRONG:
		ranged_nerve_defense_texture.texture.region = strong_nerve_region
	elif resource.ranged_defense_nerve == EnemyResource.DEFENSE.NORMAL:
		ranged_nerve_defense_texture.texture.region = normal_nerve_region
	elif resource.ranged_defense_nerve == EnemyResource.DEFENSE.WEAK:
		ranged_nerve_defense_texture.texture.region = weak_nerve_region
	elif resource.ranged_defense_nerve == EnemyResource.DEFENSE.FATAL:
		ranged_nerve_defense_texture.texture.region = fatal_nerve_region
