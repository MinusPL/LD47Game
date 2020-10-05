extends Node

# Tell Godot to ignore warnings of unused signals
#warning-ignore:unused_signal

# List of published signals
signal interaction(object)
signal addItem(item_id)
signal volume(paramName, value)
signal mute(value)
signal playerDied()
