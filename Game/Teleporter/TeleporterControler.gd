extends Area2D

enum TeleportDirection {BOTTOM, TOP, LEFT, RIGHT}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(TeleportDirection) var teleportDirection = TeleportDirection.BOTTOM
export(NodePath) var teleportPlace
# export(NodePath) var player

var monitoringObj = null
# var ableToDraw = false
# var drawRect = null

var initialPosition = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	initialPosition = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var objExtents = Vector2(get_node(player).get_node("CollisionShape2D").shape.radius, get_node(player).get_node("CollisionShape2D").shape.height)
	#var objRect = Rect2(get_node(player).position - get_node(player).getInitialPosition() - Vector2(objExtents.x, objExtents.y + objExtents.x / 2), objExtents * 2 + Vector2(0, objExtents.x))
	#get_node(player).dupa = objRect
	if monitoringObj:
		process_teleport(monitoringObj)
		# update()


func process_teleport(area):
	if !teleportPlace:
		 return
	if area.is_in_group("Player"):
		var objExtents = Vector2(area.get_node("CollisionShape2D").shape.radius, area.get_node("CollisionShape2D").shape.height) * area.scale
		var selfExtents = get_node("CollisionShape2D").shape.extents * scale
		var objRect = Rect2(area.position - Vector2(objExtents.x, objExtents.y + objExtents.x / 2), objExtents * 2 + Vector2(0, objExtents.x))
		var selfRect = Rect2(position - selfExtents, selfExtents * 2)
		# drawRect = objRect
		# get_node(player).dupa = objRect
		# get_node(player).dupa2 = selfRect
		if selfRect.encloses(objRect):
			# print(drawRect)
			# print(objRect)
			var destExtents = get_node(teleportPlace).get_node("CollisionShape2D").shape.extents * scale
			if teleportDirection == TeleportDirection.BOTTOM:
				area.teleport(get_node(teleportPlace).position + Vector2(0, destExtents.y), "down")
			if teleportDirection == TeleportDirection.TOP:
				area.teleport(get_node(teleportPlace).position + Vector2(0, -destExtents.y), "up")
			if teleportDirection == TeleportDirection.LEFT:
				area.teleport(get_node(teleportPlace).position + Vector2(-destExtents.x), "left")
			if teleportDirection == TeleportDirection.RIGHT:
				area.teleport(get_node(teleportPlace).position + Vector2(destExtents.x, 0), "right")

# func _draw():
	# print(drawRect)
#	if drawRect:
		# print("DUPA")
#		draw_rect(drawRect, Color("0000ff"), true)

func _on_Teleporter_area_shape_entered(area_id, area, area_shape, self_shape):
	monitoringObj = area
	# ableToDraw = true
	
	
func _on_Teleporter_area_shape_exited(area_id, area, area_shape, self_shape):
	monitoringObj = null # Replace with function body.
	# ableToDraw = false
