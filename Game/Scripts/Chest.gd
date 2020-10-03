extends "res://Scripts/Interactable.gd"

const Items = preload("res://Scripts/Item/Items.gd")

export (int) var item_id

var itemLooted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color(0.0,0.0,1.0,1.0)
	items.append(item_id)


func getFlavourText():
	return flavourText
	
func getName():
	print(items)
	return flavourText + " " + Items.itemDictionary[items[0]].itemName
	
func getItems():
	return items
	
func isItemLooted():
	return itemLooted
	
func setItemLooted(flag):
	itemLooted = flag
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
