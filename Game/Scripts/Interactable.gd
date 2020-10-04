extends Node

signal interaction

export var flavourText = ""
export var nameText = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func getFlavourText():
	return flavourText
	
func getName():
	return nameText

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
