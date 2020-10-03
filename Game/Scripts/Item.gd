extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var itemName = "Normal Knife"
export var desc = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getName():
	return itemName
	
func getTexture():
	return $Sprite.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
