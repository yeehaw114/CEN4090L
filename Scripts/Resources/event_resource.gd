extends Resource
class_name EventResource

@export var event_title : String
@export var event_image : Texture2D
@export_multiline var inquiry_body : String 
@export_multiline var inquiry_instinct : String 
@export_multiline var inquiry_mind : String 
@export_multiline var inquiry_will : String 
@export_multiline var inquiry_gnosis : String 

@export var decisions : Array[DecisionResource] = []
