extends Resource
class_name ResultResource

enum FAVOR {BAD,NEUTRAL,GOOD}

@export var image: Texture2D
@export_multiline var text: String
@export var inv: Inv
@export var favor: FAVOR = FAVOR.NEUTRAL

func get_fresh_inventory() -> Inv:
	if inv:
		return inv.duplicate_fresh()
	return null
