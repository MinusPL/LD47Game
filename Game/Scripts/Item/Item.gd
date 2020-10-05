extends TextureRect

var itemId
var itemName
var itemSlot
var itemDesc

func _init(_itemId, _itemName, _itemDesc, _itemTexture, _itemSlot):
	self.itemId = _itemId
	self.itemName = _itemName
	self.itemSlot = _itemSlot
	self.itemDesc = _itemDesc
	texture = _itemTexture
	rect_scale = Vector2(3.0,3.0)
	
func getItemId():
	return self.itemId
	
func getName():
	return self.itemName

func getDesc():
	return self.itemDesc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
