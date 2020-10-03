extends "res://Scripts/Interactable.gd"

export (PackedScene)var item
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color(0.0,0.0,1.0,1.0)
	items.append(item.instance())


func getFlavourText():
	return flavourText
	
func getName():
	return flavourText + " " + items[0].getName()
	
func getItems():
	return items
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
