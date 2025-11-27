extends Marker2D

var damage_popup = preload("res://Scenes/damage_popup.tscn")
const DAMAGE_OFFSET_MULTIPLIER = 20

func popup(text: String = ''):
	var damage = damage_popup.instantiate()
	get_tree().current_scene.add_child(damage)
	damage.position = global_position + random_point_offset(DAMAGE_OFFSET_MULTIPLIER)
	print('\nDAMAGE POPUP GLOBAL POSITION: '+str(damage.position)+'\n')
	damage.set_text(text)

func random_point_offset(mult_factor: int):
	var random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	random_vector = random_vector.normalized()
	random_vector *= max(randf_range(0, 1), randf_range(0, 1))
	return random_vector * mult_factor
