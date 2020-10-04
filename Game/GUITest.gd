extends Node

enum InteractionState {NONE, MAIN, QUESTION, INVENTORY, ACCUSATION, EXIT, ANSWER, INVENTORY_ANSWER}

var player = null

var current_interactable = null
var npc_interaction_state = InteractionState.NONE
var menu_option = 0
var timestamp = OS.get_ticks_msec()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Eventbus.connect("interaction", self, "_onInteraction")
	player = get_parent().get_node("Player")

func _onInteraction(object):
	if object.is_in_group("NPC"):
		if (OS.get_ticks_msec() - timestamp) > 100:
			$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
			$CanvasLayer/DialogueContainer/DialogueText.text = object.getDesc()
			npc_interaction_state = InteractionState.MAIN
			current_interactable = object
			player.setInteraction(true)
			timestamp = OS.get_ticks_msec()
	else:
		$CanvasLayer/DialogueContainer/NameBackground/Label.text = object.getName()
		$CanvasLayer/DialogueContainer/DialogueText.text = object.getFlavourText()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if npc_interaction_state != InteractionState.NONE:
		process_interaction()
		
	
func process_interaction():
	if npc_interaction_state == InteractionState.MAIN:
		var available_interactions_strings = ["  Ask a question.", "  Show item.", "  Accuse.", "  Leave."]
		available_interactions_strings[menu_option][0] = ">"
		$CanvasLayer/DialogueContainer/DialogueText.text = PoolStringArray(available_interactions_strings).join("\n")
		if (OS.get_ticks_msec() - timestamp) > 100:
			if Input.is_action_pressed("ui_up") and menu_option > 0:
				menu_option -= 1
				timestamp = OS.get_ticks_msec()
			if Input.is_action_pressed("ui_down") and menu_option < available_interactions_strings.size() - 1:
				menu_option += 1
				timestamp = OS.get_ticks_msec()
			if Input.is_action_pressed("ui_accept"):
				npc_interaction_state = menu_option + InteractionState.QUESTION
				menu_option = 0
				timestamp = OS.get_ticks_msec()
	elif npc_interaction_state == InteractionState.QUESTION:
		var available_interactions_strings = current_interactable.getQuestions().keys()
		available_interactions_strings += ["No more questions."]
		for i in range(len(available_interactions_strings)):
			if i == menu_option:
				available_interactions_strings[i] = "> " + available_interactions_strings[i]
			else:
				available_interactions_strings[i] = "  " + available_interactions_strings[i]
		$CanvasLayer/DialogueContainer/DialogueText.text = PoolStringArray(available_interactions_strings).join("\n")
		if (OS.get_ticks_msec() - timestamp) > 100:
			if Input.is_action_pressed("ui_up") and menu_option > 0:
				menu_option -= 1
				timestamp = OS.get_ticks_msec()
			if Input.is_action_pressed("ui_down") and menu_option < available_interactions_strings.size() - 1:
				menu_option += 1
				timestamp = OS.get_ticks_msec()
			if Input.is_action_pressed("ui_accept"):
				if menu_option == available_interactions_strings.size() - 1:
					menu_option = 0
					npc_interaction_state = InteractionState.MAIN
				else:
					npc_interaction_state = InteractionState.ANSWER
				timestamp = OS.get_ticks_msec()
	elif npc_interaction_state == InteractionState.ANSWER:
		$CanvasLayer/DialogueContainer/DialogueText.text = current_interactable.getQuestions().values()[menu_option]
		if (OS.get_ticks_msec() - timestamp) > 100:
			if Input.is_action_pressed("ui_accept"):
				npc_interaction_state = InteractionState.QUESTION
				menu_option = 0
				timestamp = OS.get_ticks_msec()
	elif npc_interaction_state == InteractionState.INVENTORY:
		var item_slots = $CanvasLayer/Inventory.getItemsSlots()
		$CanvasLayer/DialogueContainer/DialogueText.text = "Select item."
		if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
			item_slots[menu_option].setActiveFlag(true)
		if (OS.get_ticks_msec() - timestamp) > 100:
			if len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount():
				if Input.is_action_pressed("ui_left") and menu_option > 0:
					item_slots[menu_option].setActiveFlag(false)
					menu_option -= 1
					timestamp = OS.get_ticks_msec()
				if Input.is_action_pressed("ui_right") and menu_option < (len(item_slots) - $CanvasLayer/Inventory.getFreeSlotsCount()) - 1:
					print($CanvasLayer/Inventory.getFreeSlotsCount())
					item_slots[menu_option].setActiveFlag(false)
					menu_option += 1
					timestamp = OS.get_ticks_msec()
				if Input.is_action_pressed("ui_accept"):
					item_slots[menu_option].setActiveFlag(false)
					npc_interaction_state = InteractionState.INVENTORY_ANSWER
					timestamp = OS.get_ticks_msec()
			if Input.is_action_pressed("ui_cancel"):
				item_slots[menu_option].setActiveFlag(false)
				npc_interaction_state = InteractionState.MAIN
				menu_option = 0
				timestamp = OS.get_ticks_msec()
	elif npc_interaction_state == InteractionState.INVENTORY_ANSWER:
		var item = $CanvasLayer/Inventory.getItemSlot(menu_option).getItem()
		if item.getItemId() in current_interactable.item_answers:
			$CanvasLayer/DialogueContainer/DialogueText.text = current_interactable.item_answers[item.getItemId()]
		else:
			$CanvasLayer/DialogueContainer/DialogueText.text = "Hmm... Item... Nice Item..."
		if (OS.get_ticks_msec() - timestamp) > 100:
			if Input.is_action_pressed("ui_accept"):
				timestamp = OS.get_ticks_msec()
				npc_interaction_state = InteractionState.INVENTORY
	elif npc_interaction_state == InteractionState.ACCUSATION:
		print("Interaction")
		npc_interaction_state = InteractionState.MAIN
		timestamp = OS.get_ticks_msec()
	elif npc_interaction_state == InteractionState.EXIT:
		current_interactable = null
		npc_interaction_state = InteractionState.NONE
		player.setInteraction(false)
		$CanvasLayer/DialogueContainer/DialogueText.text = ""
		timestamp = OS.get_ticks_msec()

	
