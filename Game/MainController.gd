extends Node

onready var DeadBody = preload("res://DeadBody/DeadBody.tscn")


enum GameState{INITIAL, FURTHER}

var deadBodies = []
export (NodePath) var player = null
export (Array, String) var welcomeTextList = [""]
export var knifeId = 0
export var blackoutTime_ms = 2000
var gameState = GameState.INITIAL
var killedCounter = 0
var menuOpened = false
var inventoryOpen = false
var objectDescriptionShown = false
var blackoutTimestamp = OS.get_ticks_msec() - blackoutTime_ms
# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Menu.visible = false
	$Blackout/Panel.hide()
	deadBodies.append($DeadBody)
	Eventbus.connect("playerDied", self, "_onPlayerDied")

func resetGame():
	for deadbody in deadBodies:
		deadbody.setItemLooted(true)
	var chests = get_tree().get_nodes_in_group("Chest")
	for chest in chests:
		var index = deadBodies.find(chest)
		if (index == -1) or (index == (len(deadBodies) - 1)):
			chest.resetItems()
			
	get_node(player).teleport(get_node(player).getInitialPosition(), "down")
	get_node(player).resetCoatColor()
	$UI/CanvasLayer/Inventory.removeAllItems()
	gameState = GameState.INITIAL
	$UI/CanvasLayer/DialogueContainer.hide()
	$UI/CanvasLayer/Inventory.hide()
	setInventoryOpen(false)
	get_node(player).setInteraction(false)
	$UI.setLockedTimestamp()
	$UI.setInventoryLocked(false)
	$UI.resetStates()
	
func killPlayer():
	var deadbody = DeadBody.instance()
	deadbody.position = get_node(player).position
	deadBodies.append(deadbody)
	add_child(deadbody)
	deadbody.clearChest()
	deadbody.insertKnife(knifeId)
	deadbody.setCoatColor(get_node(player).getCoatColor())
	get_node(player).resetInteractionsAvailable()
	killedCounter += 1
	
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
	if OS.get_ticks_msec() - blackoutTimestamp < blackoutTime_ms:
			get_node(player).setInteraction(true)
			$Blackout/Panel.show()
			$UI.setInventoryLocked(true)
	else:
		$Blackout/Panel.hide()
		if gameState == GameState.INITIAL:
			setInventoryOpen(true)
			get_node(player).setInteraction(true)
			$UI.setInventoryLocked(true)
			$UI/CanvasLayer/DialogueContainer.show()
			$UI/CanvasLayer/DialogueContainer/NameBackground/Label.text = "Butler"
			$UI/CanvasLayer/DialogueContainer/DialogueText.text = welcomeTextList[killedCounter] if killedCounter < welcomeTextList.size() else welcomeTextList[-1]
			if Input.is_action_just_pressed("ui_accept"):
				setInventoryOpen(false)
				get_node(player).setInteraction(false)
				$UI.setLockedTimestamp()
				$UI.setInventoryLocked(false)
				$UI/CanvasLayer/DialogueContainer.hide()
				$UI/CanvasLayer/DialogueContainer/NameBackground/Label.text = ""
				$UI/CanvasLayer/DialogueContainer/DialogueText.text = ""
				gameState = GameState.FURTHER
		else:
			if !menuOpened and not inventoryOpen:
				if Input.is_action_just_pressed("ui_menu"):
					get_node(player).setInteraction(true)
					$Menu/Menu.visible = true
					$Menu.setLock(false)
					menuOpened = true
	
