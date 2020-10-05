extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var interactionsAvailable = 20
export var m_iMoveSpeed = 200
var m_vLastDirection = Vector2(0,1)
var m_sDirection = "down"
var initialPosition = Vector2(0,0)
var lock_movment = false
var interaction = false
var initialActionsAvaiable = 20

var interactionDistance = [Vector2(0,20), Vector2(0,-20), Vector2(-12, 0), Vector2(12, 0)]

func getInitialPosition():
	return initialPosition

func teleport(newPosition: Vector2, direction: String):
	position = newPosition
	m_sDirection = direction
	lock_movment = true
	
func setInteraction(value: bool):
	interaction = value
	
func getCoatColor():
	return $Coat.modulate
	
func resetCoatColor():
	$Coat.modulate = Color(randf(),randf(),randf())
	
func resetInteractionsAvailable():
	interactionsAvailable = initialActionsAvaiable
	
func decreaseInteractionsAvailable():
	interactionsAvailable -= 1
	
func setInteractionsAvailable(value: int):
	interactionsAvailable = value
	
func getInteractionsAvailable():
	return interactionsAvailable

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Coat.modulate = Color(randf(),randf(),randf())
	initialPosition = position
	initialActionsAvaiable = interactionsAvailable
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()

	if !interaction:
		if !lock_movment:
			if Input.is_action_pressed("ui_right"):
				velocity.x += 1
			if Input.is_action_pressed("ui_left"):
				velocity.x -= 1
			if Input.is_action_pressed("ui_up"):
				velocity.y -= 1
			if Input.is_action_pressed("ui_down"):
				velocity.y += 1
		else:
			if !(Input.is_action_pressed("ui_right") ||  Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down")):
				lock_movment = false
		if Input.is_action_just_pressed("ui_accept"):
			interact()

	if velocity.length() > 0:
		m_vLastDirection = velocity
		velocity = velocity.normalized() * m_iMoveSpeed
		$AnimatedSprite.animation = "walk_"+m_sDirection
		$Coat.animation = "walk_"+m_sDirection
		$AnimatedSprite.play()
		$Coat.play()
	else:
		$AnimatedSprite.animation = "walk_"+m_sDirection
		$Coat.animation = "walk_"+m_sDirection
		$AnimatedSprite.stop()
		$Coat.stop()
		$AnimatedSprite.frame = 0
		$Coat.frame = 0

	move_and_collide(velocity * delta)

	var normalizedDirection = m_vLastDirection.normalized()
		
	if normalizedDirection.y >= 0.707:
		m_sDirection = "down"
		$InteractionRange.position = interactionDistance[0]
	elif normalizedDirection.y <= -0.707:
		m_sDirection = "up"
		$InteractionRange.position = interactionDistance[1]
	elif normalizedDirection.x <= -0.707:
		m_sDirection = "left"
		$InteractionRange.position = interactionDistance[2]
	elif normalizedDirection.x >= 0.707:
		m_sDirection = "right"
		$InteractionRange.position = interactionDistance[3]

func interact():
	if !interaction:
		var other = $InteractionRange.get_overlapping_areas() + $InteractionRange.get_overlapping_bodies()
		print(other)
		if other:
			if other[0].get_parent().is_in_group("Interactable"):
				Eventbus.emit_signal("interaction", other[0].get_parent())


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.is_playing() and ($AnimatedSprite.frame == 0 or $AnimatedSprite.frame == 2):
		$footstep.play()	
	
