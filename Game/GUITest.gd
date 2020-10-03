extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("interaction", self, "_onInteraction")


func _onInteraction(object):
	$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
	$CanvasLayer/DialogueContainer/DialogueText.text = object.getFlavourText()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
