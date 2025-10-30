extends Node2D

@onready var player_attack_sound: AudioStreamPlayer2D = $PlayerAttackSound
@onready var enemy_death_sound: AudioStreamPlayer2D = $EnemyDeathSound
@onready var enemy_buff_sound: AudioStreamPlayer2D = $EnemyBuffSound
@onready var enemy_debuff_sound: AudioStreamPlayer2D = $EnemyDebuffSound

func play_attack():
	player_attack_sound.play()
	
func play_death():
	enemy_death_sound.play()
	
func play_buff():
	enemy_buff_sound.play()
	
func play_debuff():
	enemy_debuff_sound.play()
