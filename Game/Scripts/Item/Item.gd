extends TextureRect

var itemId
var itemName
var itemSlot
var slotType

func _init(_itemId, _itemName, _itemTexture, _itemSlot):
	self.itemId = _itemId
	self.itemName = _itemName
	self.itemSlot = _itemSlot
	texture = _itemTexture
	rect_scale = Vector2(3.0,3.0)
	
func getItemId():
	return self.itemId

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
