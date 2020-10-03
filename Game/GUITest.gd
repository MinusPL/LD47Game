extends Node

var player = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("interaction", self, "_onInteraction")
	player = get_parent().get_node("Player")


func _onInteraction(object):
	if object.is_in_group("NPC"):
		$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
		$CanvasLayer/DialogueContainer/DialogueText.text = object.getDesc()
	else:
		$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
		$CanvasLayer/DialogueContainer/DialogueText.text = object.getFlavourText()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var inventory = player.getInventory()
	if inventory.size() > 0:
		$CanvasLayer/Inventory/Panel/HBoxContainer/Slot1.texture = inventory[0].getTexture()
	
