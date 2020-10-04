extends "res://Scripts/Chest.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Sprite.modulate = Color(randf(),randf(),randf())
	
	
func insertKnife(knifeId: int):
	items.append(knifeId)
	
func setCoatColor(coatColor: Color):
	$Sprite.modulate = coatColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
