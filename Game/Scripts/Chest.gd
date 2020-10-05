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
	items.append(item_id)

func clearChest():
	items.clear()

func resetItems():
	itemLooted = false
	items.append(item_id)

func getFlavourText():
	return flavourText
	
func getName():
	return nameText

func getItemName():
	return Items.itemDictionary[items[0]].itemName
	
func getItems():
	return items
	
func isItemLooted():
	return itemLooted
	
func isChestEmpty():
	return len(items) == 0
	
func setItemLooted(flag):
	itemLooted = flag
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
