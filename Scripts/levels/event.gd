extends Control
class_name Event

@onready var scroll_container: ScrollContainer = $Panel/ScrollContainer

@onready var title_label: RichTextLabel = $Panel/ScrollContainer/VBoxContainer/TitleLabel
@onready var event_texture: TextureRect = $Panel/ScrollContainer/VBoxContainer/ImagePanel/EventTexture

@onready var inquiry_panel: Panel = $Panel/ScrollContainer/VBoxContainer/InquiryPanel
@onready var inquiry_text: RichTextLabel = $Panel/ScrollContainer/VBoxContainer/InquiryText

@onready var decision_panel: Panel = $Panel/ScrollContainer/VBoxContainer/DecisionPanel
@onready var result_label: RichTextLabel = $Panel/ScrollContainer/VBoxContainer/ResultLabel
@onready var continue_button: Button = $Panel/ScrollContainer/VBoxContainer/ContinueButton
@onready var result_image_panel: Panel = $Panel/ScrollContainer/VBoxContainer/ResultImagePanel
@onready var result_image: TextureRect = $Panel/ScrollContainer/VBoxContainer/ResultImagePanel/ResultImage
@onready var center_container: Panel = $Panel/ScrollContainer/VBoxContainer/CenterContainer
@onready var inventory_result: Control = $Panel/ScrollContainer/VBoxContainer/CenterContainer/InventoryLevel


const test_resource := preload("res://Assets/Resources/events/man_confused.tres")
enum SKILLS {BOD=1,INS=2,MIN=3,WILL=4,GNO=5}

signal event_finished
signal result_inventory_decided(inv: Inv)

@export var eventResource : EventResource

func _ready() -> void:
	if not eventResource:
		eventResource = test_resource
	title_label.text = eventResource.event_title
	event_texture.texture = eventResource.event_image
	
func _on_skill_button_pressed(index: int):
	if index == SKILLS.BOD:
		set_inquiry_text(eventResource.inquiry_body)
	elif index == SKILLS.INS:
		set_inquiry_text(eventResource.inquiry_instinct)
	elif index == SKILLS.MIN:
		set_inquiry_text(eventResource.inquiry_mind)
	elif index == SKILLS.WILL:
		set_inquiry_text(eventResource.inquiry_will)
	elif index == SKILLS.GNO:
		set_inquiry_text(eventResource.inquiry_gnosis)
		
func set_inquiry_text(text: String):
	inquiry_panel.disable_all_buttons()
	inquiry_text.show()
	decision_panel.set_decision_buttons(eventResource.decisions)
	decision_panel.show()
	inquiry_text.text = text
	call_deferred("_scroll_to_bottom")

func decision_made(text: String,image: Texture2D,inventory: Inv):
	result_label.text = text
	result_image.texture = image
	result_image_panel.show()
	result_label.show()
	
	if inventory:
		center_container.show()
		set_inventory(inventory)
		result_inventory_decided.emit(inventory)
	
	continue_button.show()
	call_deferred("_scroll_to_bottom")

func _on_continue_button_pressed() -> void:
	hide()
	event_finished.emit()

func _scroll_to_bottom() -> void:
	await get_tree().process_frame
	await get_tree().process_frame # <-- important for RichTextLabel
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func set_inventory(inventory: Inv):
	inventory_result.inv = inventory
	inventory_result.spawn_slots(inventory_result.inv.columns,inventory_result.inv.slots.size())
