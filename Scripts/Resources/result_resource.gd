extends Resource
class_name ResultResource

enum FAVOR {BAD,NEUTRAL,GOOD}

@export var image: Texture2D
@export_multiline var text: String
@export var inv: Inv
@export var favor: FAVOR = FAVOR.NEUTRAL
