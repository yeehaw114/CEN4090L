extends StaticBody2D

@onready var card_collection_viewer_object: Node2D = $".."

func display_card_viewer():
	card_collection_viewer_object.display_card_collection_viewer()
