extends Control

@onready var skill_line: Line2D = $SkillLine
@onready var zone_scale := 10

var is_overlap := false

func _ready() -> void:
	skill_line.set_hit_range(zone_scale)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if is_overlap:
			print('YAY')
		else:	print('miss')


func _on_zone_area_body_entered(body: Node2D) -> void:
	is_overlap = true

func _on_zone_area_body_exited(body: Node2D) -> void:
	is_overlap = false
