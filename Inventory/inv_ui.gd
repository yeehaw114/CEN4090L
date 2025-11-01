extends Control

@onready var inv: Inv = preload("res://Inventory/playerinventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

@export var card_scene: PackedScene = preload("res://Scenes/card.tscn")
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

var is_open = false

func _ready():
	var test_card: CardResource = preload("res://Inventory/Items/testcard.tres")
	add_card_to_inventory(test_card)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	#if Input.is_action_just_pressed("i"):
		#if is_open:
			#close()
		#else:
			#open()
	pass

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func add_card_to_inventory(card_stat: CardResource) -> void:
	var new_card = card_scene.instantiate()
	new_card.card_stats = card_stat
	new_card.is_able_to_be_selected = false
	grid_container.add_child(new_card)
	inv.insert(card_stat)
	update_slots()  
