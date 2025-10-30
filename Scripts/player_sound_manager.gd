extends Node2D

@onready var player_hurt_sound: AudioStreamPlayer2D = $PlayerHurtSound
@onready var player_move_sound: AudioStreamPlayer2D = $PlayerMoveSound
@onready var player_buff_sound: AudioStreamPlayer2D = $PlayerBuffSound
@onready var player_debuff_sound: AudioStreamPlayer2D = $PlayerDebuffSound

func play_hurt():
	player_hurt_sound.play()

func play_move():
	player_move_sound.play()

func play_buff():
	player_buff_sound.play()
	
func play_debuff():
	player_debuff_sound.play()
