extends Node

var all_battles : Array[BattleResource] = []
var all_boss_battles : Array[BattleResource] = []
var battle_file_path := "res://Assets/Resources/battles/"

func _ready() -> void:
	get_all_battles()

func get_all_battles():
	# Open dir
	var dir := DirAccess.open(battle_file_path)
	if dir == null:
		push_error("Could not open directory: " + battle_file_path)
		return
		
	var battles: Array[BattleResource] = []
	var boss_battles: Array[BattleResource] = []

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# skip directories and hidden entries like '.' '..'
		if not dir.current_is_dir() and not file_name.begins_with("."):
			if file_name.ends_with(".tres") or file_name.ends_with(".res") or file_name.ends_with(".tres.remap"):
				var file_path := battle_file_path + file_name
				var battle_resource := ResourceLoader.load(file_path)
				if battle_resource and !battle_resource.boss:
					battles.append(battle_resource)
				elif battle_resource and battle_resource.boss:
					boss_battles.append(battle_resource)
				else:
					push_warning("Failed to load resource: " + file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	all_battles = battles
	all_boss_battles = boss_battles

func get_all_battles_by_difficulty(index: int) -> Array[BattleResource]:
	var final_battles : Array[BattleResource] = []
	
	if index == BattleResource.DIFFICULTY.EASY:
		for battle in all_battles:
			if battle.difficulty == BattleResource.DIFFICULTY.EASY:
				final_battles.append(battle)
		return final_battles
	elif index == BattleResource.DIFFICULTY.MEDIUM:
		for battle in all_battles:
			if battle.difficulty == BattleResource.DIFFICULTY.MEDIUM:
				final_battles.append(battle)
		return final_battles
	else:
		for battle in all_battles:
			if battle.difficulty == BattleResource.DIFFICULTY.HARD:
				final_battles.append(battle)
		return final_battles

func get_all_boss_battles():
	return all_boss_battles

func get_random_battle_by_difficulty(index: int) -> BattleResource:
	var battles = get_all_battles_by_difficulty(index)
	return battles.pick_random()
	
func get_random_boss_battle():
	return get_all_boss_battles().pick_random()
