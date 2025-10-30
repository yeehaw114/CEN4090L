extends Node2D

@onready var battle_won_sound: AudioStreamPlayer2D = $BattleWonSound
@onready var battle_loss_sound: AudioStreamPlayer2D = $BattleLossSound

func play_won():
	battle_won_sound.play()
	
func play_loss():
	battle_loss_sound.play()
