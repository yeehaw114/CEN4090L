extends Panel

@onready var button_container: HBoxContainer = $ButtonContainer
@onready var event: Event = $"../../../.."

signal decision_made(text: String, image: Texture2D)

func set_decision_buttons(buttons: Array[DecisionResource]):
	for node in button_container.get_children():
		node.queue_free()
	
	for button in buttons:
		var new_button_node = Button.new()
		button_container.add_child(new_button_node)
		new_button_node.text = button.decision_text

		new_button_node.pressed.connect(_on_decision_pressed.bind(button))

func _on_decision_pressed(button: DecisionResource):
	for b in button_container.get_children():
		b.disabled = true
	var final_decision = button.results.pick_random()
	var image = final_decision.image
	var text = final_decision.text
	decision_made.emit(text,image)
