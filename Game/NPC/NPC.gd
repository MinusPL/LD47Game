extends KinematicBody2D

export var nameText = ""
export var descText = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getName():
	return nameText
	
func getDesc():
	return descText
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
