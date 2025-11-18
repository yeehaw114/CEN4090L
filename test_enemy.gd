extends CharacterBody2D

@export var speed = 80
@export var battle_resources: Array[BattleResource]
@export var is_boss := false

var player = null
var is_dead = false

@onready var detect_area = $DetectArea
@onready var body_area = $BodyArea
@onready var collision_shape_2d_body: CollisionShape2D = $BodyArea/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	detect_area.body_entered.connect(_on_detect_entered)
	detect_area.body_exited.connect(_on_detect_exited)
	body_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if player and !is_dead:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_detect_entered(body):
	if body.name == "Player":
		player = body

func _on_detect_exited(body):
	if body == player:
		player = null

func _on_body_entered(body):
	if body.name == "Player" and !is_dead:
		call_deferred("_handle_battle_transition")

func get_battle_resource() -> BattleResource:
	battle_resources.shuffle()
	return battle_resources.pop_front()

func set_cards_on_battle(battle: BattleResource):
	battle.starting_cards.clear()
	battle.starting_cards = GameState.transferred_cards.duplicate(true)
	GameState.pending_battle_resource = battle

func _handle_battle_transition():
	var tree = get_tree()
	var current_room = tree.current_scene
	
	if !is_boss:
		if GameState.rooms_cleared >= 7:
			var battle = GlobalBattleResourceManager.get_random_battle_by_difficulty(BattleResource.DIFFICULTY.HARD)
			set_cards_on_battle(battle)
		elif GameState.rooms_cleared >= 3:
			var battle = GlobalBattleResourceManager.get_random_battle_by_difficulty(BattleResource.DIFFICULTY.MEDIUM)
			set_cards_on_battle(battle)
		else:
			var battle = GlobalBattleResourceManager.get_random_battle_by_difficulty(BattleResource.DIFFICULTY.EASY)
			set_cards_on_battle(battle)
	else:
		var battle = GlobalBattleResourceManager.get_random_boss_battle()
		set_cards_on_battle(battle)
		
	
	hide()
	is_dead = true
	collision_shape_2d.disabled = true
	collision_shape_2d_body.disabled = true
	#Detach current scene safely (now outside physics)
	tree.root.remove_child(current_room)
	GameState.previous_scene = current_room

	#Change scene to battle
	GlobalAudioStreamPlayer.play_battle_music()
	GameState.change_scene(GameState.SCENES["battle"])
