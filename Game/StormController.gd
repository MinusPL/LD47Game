extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var light_timer = 0.0
export var minLightningTime = 15.0
export var randomLightningTime = 45.0
export var minThunderTime = 0.0
export var randomThunderTime = 0.2
var currentLightningTime = 0.0
var currentThunderTime = 0.0

var lighton_timer = 0.0
var thunderon_timer = 0.0

var lightning = false
var lightning_state = 0
var thunder_state = 0
var thunder = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("Storm").hide()
	get_parent().get_node("Storm2").hide()
	randomize()
	currentLightningTime = minLightningTime + randf()*randomLightningTime
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light_timer += delta
	
	if light_timer >= currentLightningTime:
		lightning = true
		
	processLightning(delta)
	processThunder(delta)
	
func processLightning(delta):
	if lightning:
		if lightning_state == 0:
			get_parent().get_node("Storm").show()
			get_parent().get_node("Storm2").show()
			lightning_state = 1
			thunder = true
			currentThunderTime = minThunderTime + randf()*randomThunderTime
		elif lightning_state == 1:
			lighton_timer += delta
			if lighton_timer >= 1.5:
				get_parent().get_node("Storm").hide()
				get_parent().get_node("Storm2").hide()
				lightning_state = 0
				currentLightningTime = minLightningTime + randf()*randomLightningTime
				light_timer = 0.0
				lighton_timer = 0.0
				lightning = false

func processThunder(delta):
	if thunder:
		if thunder_state == 0:
			thunderon_timer += delta
			if thunderon_timer >= currentThunderTime:
				thunder = false
				var thunderNumber = randi() % 2
				print("thunder%d"%thunderNumber)
				get_node("thunder%d"%thunderNumber).play()
				thunderon_timer = 0.0
		elif thunder_state == 1:
			pass
