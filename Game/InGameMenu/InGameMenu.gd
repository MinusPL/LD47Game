extends CanvasLayer


enum MenuOptions {NONE, RESTART, OPTIONS, EXIT}
enum OptionsOptions {TOGGLE, SOUND_VOLUME, MUSIC_VOLUME}

export (NodePath) var mainController

var highlighted_menu_option = 0
var secondary_highlighted_menu_option = 0
var selected_menu_option = MenuOptions.NONE
var timestamp = OS.get_ticks_msec()
var key_delay = 2000
var first_click = true

var lock = true
var lock_timestamp = OS.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func setLock(value: bool):
	lock = value
	lock_timestamp = OS.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !lock:
		var main_children = $Menu/Panel/MenuContainer/VBoxContainer/Options.get_children()
		var options_children = $Menu/Panel/MenuContainer/OptionsOptions.get_children()
		
		for i in range(4):
			if (highlighted_menu_option - i) >= 0:
				var child: Label = main_children[highlighted_menu_option - i]
				child.modulate.a = clamp(1 - 0.25 * i, 0, 1)
			if (highlighted_menu_option + i) < len(main_children):
				var child: Label = main_children[highlighted_menu_option + i]
				child.modulate.a = clamp(1 - 0.25 * i, 0, 1)
				
		for i in range(4):
			if (secondary_highlighted_menu_option - i) >= 0:
				for child in options_children[secondary_highlighted_menu_option - i].get_children():
					child.modulate.a = clamp(1 - 0.25 * i, 0, 1)
			if (secondary_highlighted_menu_option + i) < len(options_children):
				for child in options_children[secondary_highlighted_menu_option + i].get_children():
					child.modulate.a = clamp(1 - 0.25 * i, 0, 1)
				
		if selected_menu_option == MenuOptions.NONE:
			$Menu/Panel/MenuContainer/OptionsOptions.visible = false
			if Input.is_action_just_pressed("ui_up"):
				if highlighted_menu_option > 0:
					highlighted_menu_option -= 1
			if Input.is_action_just_pressed("ui_down"):
				if highlighted_menu_option < len(main_children) - 1:
					highlighted_menu_option += 1
			if Input.is_action_just_pressed("ui_accept"):
				selected_menu_option = highlighted_menu_option + 1
			if OS.get_ticks_msec() - lock_timestamp > 100:
				if Input.is_action_just_pressed("ui_cancel"):
					get_node(mainController).closeMenu()
		elif selected_menu_option == MenuOptions.RESTART:
			selected_menu_option = MenuOptions.NONE
			get_tree().change_scene("res://Main.tscn")
		elif selected_menu_option == MenuOptions.OPTIONS:
			$Menu/Panel/MenuContainer/OptionsOptions.visible = true
			$Menu/Panel/MenuContainer/OptionsOptions/HBoxContainer/SoundToggleValue.text = "On" if Globals.play_audio else "Off"
			$Menu/Panel/MenuContainer/OptionsOptions/HBoxContainer2/SoundVolumeValue.text = "%d" % Globals.sound_volume
			$Menu/Panel/MenuContainer/OptionsOptions/HBoxContainer3/MusicVolumeValue.text = "%d" % Globals.music_volume
			if Input.is_action_just_pressed("ui_up"):
				if secondary_highlighted_menu_option > 0:
					secondary_highlighted_menu_option -= 1
			if Input.is_action_just_pressed("ui_down"):
				if secondary_highlighted_menu_option < len(options_children) - 1:
					secondary_highlighted_menu_option += 1
			if Input.is_action_just_pressed("ui_cancel"):
				selected_menu_option = MenuOptions.NONE
			if Input.is_action_pressed("ui_left"):
				if OS.get_ticks_msec() - timestamp > key_delay:
					if secondary_highlighted_menu_option == OptionsOptions.TOGGLE:
						Globals.play_audio = !Globals.play_audio
						AudioServer.set_bus_mute(0, !Globals.play_audio)
					if secondary_highlighted_menu_option == OptionsOptions.MUSIC_VOLUME:
						if Globals.music_volume > 0:
							Globals.music_volume -= 1
							AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(Globals.music_volume/100.0))
					if secondary_highlighted_menu_option == OptionsOptions.SOUND_VOLUME:
						if Globals.sound_volume > 0:
							Globals.sound_volume -= 1
							AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear2db(Globals.sound_volume/100.0))
					if first_click:
						key_delay = 500
						first_click = false
					else:
						key_delay = 100
					timestamp = OS.get_ticks_msec()
			elif Input.is_action_pressed("ui_right"):
				if OS.get_ticks_msec() - timestamp > key_delay:
					if secondary_highlighted_menu_option == OptionsOptions.TOGGLE:
						Globals.play_audio = !Globals.play_audio
						AudioServer.set_bus_mute(0, !Globals.play_audio)
					if secondary_highlighted_menu_option == OptionsOptions.MUSIC_VOLUME:
						if Globals.music_volume < 100:
							Globals.music_volume += 1
							AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(Globals.music_volume/100.0))
					if secondary_highlighted_menu_option == OptionsOptions.SOUND_VOLUME:
						if Globals.sound_volume < 100:
							Globals.sound_volume += 1
							AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear2db(Globals.sound_volume/100.0))
					if first_click:
						key_delay = 500
						first_click = false
					else:
						key_delay = 100
					timestamp = OS.get_ticks_msec()
			else:
				first_click = true
				key_delay = 0
		elif selected_menu_option == MenuOptions.EXIT:
			selected_menu_option = MenuOptions.NONE
			get_tree().change_scene("res://MainMenu/MainMenuScene.tscn")
