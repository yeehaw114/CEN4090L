extends Control

@onready var player_line: Line2D = $BattleManager/PlayerLine
@onready var player: Enemy = $BattleManager/PlayerLine/Player

func _ready() -> void:
	pass
	#print(rank_4_position.get_global_rect().position)
	#print(rank_4_position2.get_global_rect().position)
	#player.position = rank_4_position.get_global_rect().position
	#print(rank_4_container.get_global_rect().position)
	#print(rank_container_2.get_global_rect().position)
	divide_line_into_4()
	
func divide_line_into_4():
	var begin_point := player_line.get_point_position(0)
	var y_pos := begin_point.y
	var end_point := player_line.get_point_position(1)
	var total_distance := end_point.x - begin_point.x
	var new_point : Vector2
	var step_distance := (int(total_distance/5))
	var points : Array = []
	
	print('begin: '+str(begin_point))
	print('end: '+str(end_point))
	for i in 6:
		new_point = Vector2(begin_point.x+step_distance*(i),y_pos)
		points.append(new_point)
	points.pop_front()
	points.pop_back()
	print(points)
	player_line.clear_points()
	for point in points:
		player_line.add_point(point)
	for p in player_line.get_point_count():
		print(player_line.get_point_position(p))
		
	player.position = player_line.get_point_position(3)


func _on_movement_button_pressed() -> void:
	print('movement button pressed')

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var rank_tile = raycast_check_for_rank_position()

func raycast_check_for_rank_position():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		if result[0].collider.get_parent().is_in_group("Tile"):
			var tile = result[0].collider.get_parent()
			print(str(tile.rank) + ' '+ str(tile.character))
