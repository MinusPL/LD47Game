extends Node

onready var DeadBody = preload("res://DeadBody/DeadBody.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var deadBodies = []
export (NodePath) var player = null
export var knifeId = 0
export var blackoutTime_ms = 2000
var menuOpened = false
var inventoryOpen = false
var objectDescriptionShown = false
var blackoutTimestamp = OS.get_ticks_msec() - blackoutTime_ms
# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Menu.visible = false
	$Blackout/Panel.hide()
	Eventbus.connect("playerDied", self, "_onPlayerDied")

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
	get_node(player).resetInteractionsAvailable()
	
func closeMenu():
	get_node(player).setInteraction(false)
	$Menu/Menu.visible = false
	$Menu.setLock(true)
	menuOpened = false
	
func _onPlayerDied():
	$Blackout/Panel.hide()
	blackoutTimestamp = OS.get_ticks_msec()
	killPlayer()
	resetGame()
	
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
			
	if OS.get_ticks_msec() - blackoutTimestamp < blackoutTime_ms:
		get_node(player).setInteraction(true)
		$Blackout/Panel.show()
	else:
		get_node(player).setInteraction(false)
		$Blackout/Panel.hide()
	
