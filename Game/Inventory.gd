extends Panel

const ItemSlot = preload("res://UI/ItemSlot.gd");
const Items = preload("res://Scripts/Item/Items.gd")
const Item = preload("res://Scripts/Item/Item.gd")

const MAX_SLOTS = 17;

var slotList = Array();

func _ready():
	Eventbus.connect("addItem", self, "_onAddItem")
	var slots = get_node("Slots");
	for _i in range(MAX_SLOTS):
		var slot = ItemSlot.new();
		#slot.connect("mouse_entered", self, "mouse_enter_slot", [slot]);
		#slot.connect("mouse_exited", self, "mouse_exit_slot", [slot]);
		#slot.connect("gui_input", self, "slot_gui_input", [slot]);
		slotList.append(slot);
		slots.add_child(slot);

func getFreeSlot():
	for slot in slotList:
		if !slot.item:
			return slot;
			
func getFreeSlotsCount():
	var count = 0
	for slot in slotList:
		if !slot.item:
			count += 1
	return count

func addItem(id):
	var slot = getFreeSlot();
	if slot:
		var item = Items.itemDictionary[id];
		slot.setItem(Item.new(id, item.itemName, item.texture, slot))
		
func removeAllItems():
	for slot in slotList:
		slot.removeItem()
		
func getItemsSlots():
	return slotList
	
func getItemSlot(index):
	return slotList[index]

func _onAddItem(item):
	addItem(item)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
