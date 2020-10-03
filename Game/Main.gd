extends Node2D

export (Rect2) var debugRect1 = null;
export (Rect2) var debugRect2 = null;

func _draw():
	if debugRect1:
		draw_rect(debugRect1, Color("ff0000"), true)
	if debugRect2:
		draw_rect(debugRect1, Color("0000ff"), true)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#update()
#	pass
