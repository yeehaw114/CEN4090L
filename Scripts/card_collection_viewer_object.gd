extends Node2D

signal interacted_with

func display_card_collection_viewer():
	interacted_with.emit()
