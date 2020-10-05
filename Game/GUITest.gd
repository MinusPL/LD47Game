extends Node

enum InteractionState {NONE, MAIN, QUESTION, INVENTORY, ACCUSATION, EXIT, ANSWER, INVENTORY_ANSWER, DESCRIPTION}
enum DescriptionState {NONE, DESCRIPTION, ADD_ITEM}
enum InventoryState {NONE, SHOWN}

var player = null

var current_interactable = null
var npc_interaction_state = InteractionState.NONE
var menu_option = 0
var is_object_description = false
var obj_description_state = DescriptionState.NONE
var lock_timestamp = OS.get_ticks_msec()
var inv_state = InventoryState.NONE
var inventoryLocked = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func setInventoryLocked(value: bool):
	inventoryLocked = value
	
func setLockedTimestamp():
	lock_timestamp = OS.get_ticks_msec()
	
func resetStates():
	npc_interaction_state = InteractionState.NONE
	obj_description_state = DescriptionState.NONE
	inv_state = InventoryState.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("interaction", self, "_onInteraction")
	player = get_parent().get_node("Player")
	$CanvasLayer/DialogueContainer.hide()
	$CanvasLayer/Inventory.hide()

func _onInteraction(object):
	print(player.getInteractionsAvailable())
	if player.getInteractionsAvailable() > 0:
		if object.is_in_group("NPC"):
			$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
			$CanvasLayer/DialogueContainer/DialogueText.text = object.getDesc()
			npc_interaction_state = InteractionState.DESCRIPTION
			get_parent().setInventoryOpen(true)
			current_interactable = object
			player.setInteraction(true)
			inventoryLocked = true
			$CanvasLayer/DialogueContainer.show()
		else:
			player.decreaseInteractionsAvailable()
			current_interactable = object
			obj_description_state = DescriptionState.DESCRIPTION
			lock_timestamp = OS.get_ticks_msec()
			player.setInteraction(true)
			inventoryLocked = true
			get_parent().setObjectDescriptionFlag(true)
			$CanvasLayer/DialogueContainer.show()
	else:
		Eventbus.emit_signal("playerDied")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_parent().getMenuFlag():
		if npc_interaction_state != InteractionState.NONE:
			process_interaction()
		
		if obj_description_state != DescriptionState.NONE:
			process_obj_description()
		
		if inv_state != InventoryState.NONE:
			process_inventory()
			
		if Input.is_action_just_pressed("ui_select") and !inventoryLocked:
			if OS.get_ticks_msec() - lock_timestamp > 100:
				inv_state = InventoryState.SHOWN
				get_parent().setInventoryOpen(true)

func process_inventory():
	if inv_state == InventoryState.SHOWN:
		player.setInteraction(true)
		$CanvasLayer/DialogueContainer.show()
		$CanvasLayer/Inventory.show()
		var item_slots = $CanvasLayer/Inventory.getItemsSlots()
		if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
			item_slots[menu_option].setActiveFlag(true)
		if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
			if Input.is_action_just_pressed("ui_left") and menu_option > 0:
				item_slots[menu_option].setActiveFlag(false)
				menu_option -= 1
			if Input.is_action_just_pressed("ui_right") and menu_option < (len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount()) - 1:
				item_slots[menu_option].setActiveFlag(false)
				menu_option += 1
			var item = $CanvasLayer/Inventory.getItemSlot(menu_option).getItem()
			$CanvasLayer/DialogueContainer/NameBackground/Label.text = item.getName()
			$CanvasLayer/DialogueContainer/DialogueText.text = item.getDesc()
		else:
			$CanvasLayer/DialogueContainer/NameBackground/Label.text = "Inventory"
			$CanvasLayer/DialogueContainer/DialogueText.text = "Your inventory is empty."
		if Input.is_action_just_pressed("ui_cancel"):
			get_parent().setInventoryOpen(false)
			item_slots[menu_option].setActiveFlag(false)
			inv_state = InventoryState.NONE
			$CanvasLayer/DialogueContainer.hide()
			$CanvasLayer/Inventory.hide()
			player.setInteraction(false)
			menu_option = 0

func process_obj_description():
	if obj_description_state == DescriptionState.DESCRIPTION:
		$CanvasLayer/DialogueContainer/NameBackground/Label.text = current_interactable.getName()
		$CanvasLayer/DialogueContainer/DialogueText.text = current_interactable.getFlavourText()
		if Input.is_action_just_pressed("ui_accept"):
			if OS.get_ticks_msec() - lock_timestamp > 100:
				if current_interactable.is_in_group("Chest"):
					obj_description_state = DescriptionState.ADD_ITEM
				else:
					obj_description_state = DescriptionState.NONE
					player.setInteraction(false)
					inventoryLocked = false
					get_parent().setObjectDescriptionFlag(false)
					$CanvasLayer/DialogueContainer.hide()
					lock_timestamp = OS.get_ticks_msec()
	elif obj_description_state == DescriptionState.ADD_ITEM:
		if not current_interactable.isChestEmpty():
			$CanvasLayer/DialogueContainer/DialogueText.text = "You have found %s."%current_interactable.getItemName()
			if !current_interactable.isItemLooted():
				Eventbus.emit_signal("addItem", current_interactable.getItems()[0])
				current_interactable.setItemLooted(true)
		else:
			$CanvasLayer/DialogueContainer/DialogueText.text = "Nothing else to find here."
			
		if Input.is_action_just_pressed("ui_accept"):
			if OS.get_ticks_msec() - lock_timestamp > 100:
				current_interactable.clearChest()
				obj_description_state = DescriptionState.NONE
				inventoryLocked = false
				player.setInteraction(false)
				get_parent().setObjectDescriptionFlag(false)
				lock_timestamp = OS.get_ticks_msec()
				$CanvasLayer/DialogueContainer.hide()
	
func process_interaction():
	if npc_interaction_state == InteractionState.MAIN:
		var available_interactions_strings = ["  Ask a question.", "  Show item.", "  Accuse.", "  Leave."]
		available_interactions_strings[menu_option][0] = ">"
		$CanvasLayer/DialogueContainer/DialogueText.text = PoolStringArray(available_interactions_strings).join("\n")
		if Input.is_action_just_pressed("ui_up") and menu_option > 0:
			menu_option -= 1
		if Input.is_action_just_pressed("ui_down") and menu_option < available_interactions_strings.size() - 1:
			menu_option += 1
		if Input.is_action_just_pressed("ui_accept"):
			npc_interaction_state = menu_option + InteractionState.QUESTION
			menu_option = 0
	elif npc_interaction_state == InteractionState.QUESTION:
		var available_interactions_strings = current_interactable.getQuestions().keys()
		available_interactions_strings += ["No more questions."]
		for i in range(len(available_interactions_strings)):
			if i == menu_option:
				available_interactions_strings[i] = "> " + available_interactions_strings[i]
			else:
				available_interactions_strings[i] = "  " + available_interactions_strings[i]
		$CanvasLayer/DialogueContainer/DialogueText.text = PoolStringArray(available_interactions_strings).join("\n")
		if Input.is_action_just_pressed("ui_up") and menu_option > 0:
			menu_option -= 1
		if Input.is_action_just_pressed("ui_down") and menu_option < available_interactions_strings.size() - 1:
				menu_option += 1
		if Input.is_action_just_pressed("ui_accept"):
			if menu_option == available_interactions_strings.size() - 1:
				menu_option = 0
				npc_interaction_state = InteractionState.MAIN
			else:
				player.decreaseInteractionsAvailable()
				npc_interaction_state = InteractionState.ANSWER
	elif npc_interaction_state == InteractionState.ANSWER:
		$CanvasLayer/DialogueContainer/DialogueText.text = current_interactable.getQuestions().values()[menu_option]
		if Input.is_action_just_pressed("ui_accept"):
			npc_interaction_state = InteractionState.QUESTION
			menu_option = 0
	elif npc_interaction_state == InteractionState.INVENTORY:
		var item_slots = $CanvasLayer/Inventory.getItemsSlots()
		$CanvasLayer/Inventory.show()
		$CanvasLayer/DialogueContainer/DialogueText.text = "Select item."
		if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
			item_slots[menu_option].setActiveFlag(true)
		if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
			if Input.is_action_just_pressed("ui_left") and menu_option > 0:
				item_slots[menu_option].setActiveFlag(false)
				menu_option -= 1
			if Input.is_action_just_pressed("ui_right") and menu_option < (len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount()) - 1:
				print($CanvasLayer/Inventory.getFreeSlotsCount())
				item_slots[menu_option].setActiveFlag(false)
				menu_option += 1
			if Input.is_action_just_pressed("ui_accept"):
				item_slots[menu_option].setActiveFlag(false)
				player.decreaseInteractionsAvailable()
				npc_interaction_state = InteractionState.INVENTORY_ANSWER
				$CanvasLayer/Inventory.hide()
		if Input.is_action_just_pressed("ui_cancel"):
			item_slots[menu_option].setActiveFlag(false)
			$CanvasLayer/Inventory.hide()
			npc_interaction_state = InteractionState.MAIN
			menu_option = 0
	elif npc_interaction_state == InteractionState.INVENTORY_ANSWER:
		var item = $CanvasLayer/Inventory.getItemSlot(menu_option).getItem()
		if item.getItemId() in current_interactable.item_answers:
			$CanvasLayer/DialogueContainer/DialogueText.text = current_interactable.item_answers[item.getItemId()]
		else:
			$CanvasLayer/DialogueContainer/DialogueText.text = "Hmm... Item... Nice Item..."
		if Input.is_action_just_pressed("ui_accept"):
			npc_interaction_state = InteractionState.INVENTORY
	elif npc_interaction_state == InteractionState.ACCUSATION:
		player.setInteractionAvailable(0)
		npc_interaction_state = InteractionState.MAIN
	elif npc_interaction_state == InteractionState.EXIT:
		current_interactable = null
		inventoryLocked = false
		npc_interaction_state = InteractionState.NONE
		player.setInteraction(false)
		get_parent().setInventoryOpen(false)
		lock_timestamp = OS.get_ticks_msec()
		$CanvasLayer/DialogueContainer.hide()
		$CanvasLayer/DialogueContainer/DialogueText.text = ""
	elif npc_interaction_state == InteractionState.DESCRIPTION:
		if Input.is_action_just_pressed("ui_accept"):
			npc_interaction_state = InteractionState.MAIN

	
