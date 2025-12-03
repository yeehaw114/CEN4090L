extends Control

@onready var inv_ui_scene = preload("res://Inventory/inv_ui.tscn")
@onready var inv: Inv = preload("res://Inventory/playerinventory.tres")

var inv_ui_instance = null
var coin_label: Label
var health_label: Label

func _ready():
	# Start hidden
	visible = false
	
	# Create the inventory UI instance
	setup_inventory_ui()
	
	# Create coin and health display
	setup_hud_elements()

func setup_inventory_ui():
	# Instance your existing inventory UI
	if inv_ui_scene:
		inv_ui_instance = inv_ui_scene.instantiate()
		add_child(inv_ui_instance)
		
		# Position it in the center of the screen
		if inv_ui_instance:
			inv_ui_instance.set_anchors_preset(Control.PRESET_CENTER)
			inv_ui_instance.position = Vector2(-42.5, -31.5)  # Offset for 85x63 size

func setup_hud_elements():
	# Create a container for coins and health above the inventory
	var hud_container = VBoxContainer.new()
	hud_container.set_anchors_preset(Control.PRESET_CENTER)
	hud_container.position = Vector2(-50, -80)  # Position above inventory
	hud_container.add_theme_constant_override("separation", 5)
	add_child(hud_container)
	
	# Create coin label
	coin_label = Label.new()
	coin_label.text = "0 Coins"
	coin_label.add_theme_font_size_override("font_size", 16)
	coin_label.add_theme_color_override("font_color", Color(1, 0.84, 0))  # Gold color
	hud_container.add_child(coin_label)
	
	# Create health label
	health_label = Label.new()
	health_label.text = "100/100"
	health_label.add_theme_font_size_override("font_size", 16)
	health_label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))  # Red color
	hud_container.add_child(health_label)

func _input(event):
	if event.is_action_pressed("i"):
		toggle_inventory()

func _process(_delta):
	# Update display while visible
	if visible:
		update_display()

func toggle_inventory():
	visible = !visible
	if visible:
		update_display()

func update_display():
	update_coin_label()
	update_health_label()

func update_coin_label():
	if coin_label:
		# Check for GameState
		if has_node("/root/GameState"):
			var game_state = get_node("/root/GameState")
			# Try different property names
			if "coins_current" in game_state:
				coin_label.text = str(game_state.coins_current) + " Coins"
			elif "coins" in game_state:
				coin_label.text = str(game_state.coins) + " Coins"
			else:
				coin_label.text = str(inv.coins) + " Coins"
		else:
			# Use inventory resource
			coin_label.text = str(inv.coins) + " Coins"

func update_health_label():
	if health_label:
		# Check for GameState
		if has_node("/root/GameState"):
			var game_state = get_node("/root/GameState")
			var current = inv.current_health
			var max_hp = inv.max_health
			
			if "current_health" in game_state:
				current = game_state.current_health
			if "max_health" in game_state:
				max_hp = game_state.max_health
				
			health_label.text = str(current) + "/" + str(max_hp)
		else:
			# Use inventory resource
			health_label.text = str(inv.current_health) + "/" + str(inv.max_health)

# Pause integration
var was_visible_before_pause := false

func hide_for_pause():
	was_visible_before_pause = visible
	visible = false

func show_after_pause():
	visible = was_visible_before_pause
