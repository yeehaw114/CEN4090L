extends Node2D

@onready var battle_won_sound: AudioStreamPlayer2D = $BattleWonSound
@onready var battle_loss_sound: AudioStreamPlayer2D = $BattleLossSound
@onready var battle_error_sound: AudioStreamPlayer2D = $BattleErrorSound

func play_won():
	GlobalAudioStreamPlayer.stop_music()
	battle_won_sound.play()
	
func play_loss():
	GlobalAudioStreamPlayer.stop_music()
	battle_loss_sound.play()

func play_error():
	battle_error_sound.play()
