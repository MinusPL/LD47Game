extends Node

onready var DeadBody = preload("res://DeadBody/DeadBody.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var deadBodies = []
export (NodePath) var player = null
export var knifeId = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func resetGame():
	for deadbody in deadBodies:
		deadbody.setItemLooted(true)
	var chests = get_tree().get_nodes_in_group("Chest")
	print(chests)
	for chest in chests:
		var index = chests.find(chest)
		if (index == -1) or (index == (len(chests) - 1)):
			chest.setItemLooted(false)
			
	get_node(player).teleport(get_node(player).getInitialPosition(), "down")
	get_node(player).resetCoatColor()
	$Node2D/CanvasLayer/Inventory.removeAllItems()
		
func killPlayer():
	var deadbody = DeadBody.instance()
	deadbody.position = get_node(player).position
	deadBodies.append(deadbody)
	add_child(deadbody)
	deadbody.clearChest()
	deadbody.insertKnife(knifeId)
	deadbody.setCoatColor(get_node(player).getCoatColor())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
