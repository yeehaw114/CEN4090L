extends AudioStreamPlayer

const lobby_music = preload("res://Assets/Music/Soundtrack/Tree_Hub.ogg")
const dungeon_music = preload("res://Assets/Music/Soundtrack/Dungeon_Music.ogg")



func play_lobby_music():
	stream_paused = false
	if stream == lobby_music:
		return
	stream = lobby_music
	
	play()
	
func play_dungeon_music():
	stream_paused = false
	if stream == dungeon_music:
		return
	stream = dungeon_music
	
	play()
	
func stop_music():
	stream_paused = true
