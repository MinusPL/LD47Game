extends Node

onready var DeadBody = preload("res://DeadBody/DeadBody.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var deadBodies = []
export (NodePath) var player = null
export var knifeId = 0

var menuOpened = false
var inventoryOpen = false
var objectDescriptionShown = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Menu.visible = false

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
	$UI/CanvasLayer/Inventory.removeAllItems()
		
func killPlayer():
	var deadbody = DeadBody.instance()
	deadbody.position = get_node(player).position
	deadBodies.append(deadbody)
	add_child(deadbody)
	deadbody.clearChest()
	deadbody.insertKnife(knifeId)
	deadbody.setCoatColor(get_node(player).getCoatColor())
	
func closeMenu():
	get_node(player).setInteraction(false)
	$Menu/Menu.visible = false
	$Menu.setLock(true)
	menuOpened = false
	
func setMenuFlag(value: bool):
	menuOpened = value

func getMenuFlag():
	return menuOpened
	
func setInventoryOpen(value: bool):
	inventoryOpen = value
	
	
func setObjectDescriptionFlag(value):
	objectDescriptionShown = value

func _process(delta):
	if !menuOpened and not inventoryOpen:
		if Input.is_action_just_pressed("ui_menu"):
			get_node(player).setInteraction(true)
			$Menu/Menu.visible = true
			$Menu.setLock(false)
			menuOpened = true
