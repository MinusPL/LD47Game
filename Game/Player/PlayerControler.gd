extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var m_iMoveSpeed = 200
var m_vLastDirection = Vector2(1,0)
var m_sDirection = "down"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		m_vLastDirection = velocity
		velocity = velocity.normalized() * m_iMoveSpeed
		$AnimatedSprite.animation = "walk_"+m_sDirection
		$AnimatedSprite.play()

	position += velocity * delta

	var normalizedDirection = m_vLastDirection.normalized()
		
	if normalizedDirection.y >= 0.707:
		m_sDirection = "down"
	elif normalizedDirection.y <= -0.707:
		m_sDirection = "up"
	elif normalizedDirection.x <= -0.707:
		m_sDirection = "left"
	elif normalizedDirection.x >= 0.707:
		m_sDirection = "right"


	

