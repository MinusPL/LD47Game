extends Panel

var slotIndex;
var item = null;
var style;
var active = false;
var borderColorActive = Color("#a15a21")
var borderColorInactive = Color("#483d35")

func _init():
	#mouse_filter = Control.MOUSE_FILTER_PASS
	rect_min_size = Vector2(48, 48)
	rect_size = Vector2(48,48)
	style = StyleBoxFlat.new()
	refreshColors()
	style.set_border_width_all(2)
	set('custom_styles/panel', style)

func putItem(newItem):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	#get_tree().get_root().remove_child(item);
	add_child(item);
	refreshColors();

func setItem(newItem):
	add_child(newItem);
	item = newItem;
	item.itemSlot = self;
	item.rect_scale = Vector2(3.0,3.0)
	refreshColors();
	
func getItem():
	return item

func removeItem():
	remove_child(item);
	item = null;
	refreshColors();

func refreshColors():
	style.bg_color = Color(0.0,0.0,0.0,0.0);
	if !active:
		style.border_color = Color(borderColorInactive);
	else:
		style.border_color = Color(borderColorActive);
		

func setActiveFlag(value: bool):
	active = value
	refreshColors()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
