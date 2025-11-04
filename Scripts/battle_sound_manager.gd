extends Node2D

@onready var battle_won_sound: AudioStreamPlayer2D = $BattleWonSound
@onready var battle_loss_sound: AudioStreamPlayer2D = $BattleLossSound

func play_won():
	GlobalAudioStreamPlayer.stop_music()
	battle_won_sound.play()
	
func play_loss():
	GlobalAudioStreamPlayer.stop_music()
	battle_loss_sound.play()
