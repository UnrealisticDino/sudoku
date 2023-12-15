#SelectGame.gd
extends Control

var settings = ConfigFile.new()
var last_orientation = OS.get_screen_orientation()
var background_color = Color(1, 1, 1) # Default to white
var last_screen_size = OS.get_window_size()
var ButtonManager = preload("res://Sudoku/SaveFiles/ButtonManager.gd").new()

func _ready():
	last_orientation = OS.get_screen_orientation()
	load_settings()
	adjust_to_screen_orientation()
	
	var vbox_container_path = "MenuPortrait/VScrollBar/VBoxContainer"
	var vbox_container = get_node_or_null(vbox_container_path)
	
	if vbox_container:
		ButtonManager.load_buttons_state(vbox_container)
	else:
		print("Error: VBoxContainer not found at path: ", vbox_container_path)

func _process(_delta):
	var current_screen_size = OS.get_window_size()
	if current_screen_size.x != last_screen_size.x or current_screen_size.y != last_screen_size.y:
		if (current_screen_size.x > current_screen_size.y and last_screen_size.x <= last_screen_size.y) or (current_screen_size.x < current_screen_size.y and last_screen_size.x >= last_screen_size.y):
			print("Orientation changed")
			adjust_to_screen_orientation()
		last_screen_size = current_screen_size

func adjust_to_screen_orientation():
	var screen_size = OS.get_window_size()
	var is_landscape = screen_size.x > screen_size.y
	print("Is landscape: ", is_landscape, " | Screen size: ", screen_size)
	if is_landscape:
		layout_for_landscape()
	else:
		layout_for_portrait()
	last_orientation = OS.get_screen_orientation()

func layout_for_landscape():
	var menu_landscape = $MenuLandscape
	menu_landscape.visible = true

	var menu_portrait = $MenuPortrait
	menu_portrait.visible = false

func layout_for_portrait():
	var menu_portrait = $MenuPortrait
	menu_portrait.visible = true

	var menu_landscape = $MenuLandscape
	menu_landscape.visible = false

func load_settings():
	# Load your settings here
	var err = settings.load("user://settings.cfg")
	if err == OK:
		# If settings loaded successfully, apply them
		background_color = settings.get_value("graphics", "background_color", Color(0.5, 0.5, 0.5)) # Load the background color
		var sound_volume = settings.get_value("audio", "sound_volume", 1.0) # Default volume is 1.0
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(sound_volume))
		update_background_size() # Update the background color
	else:
		# If the settings file doesn't exist, you might want to create default settings
		save_settings() # This will create the file with default values

func update_background_size():
	# This ensures the ColorRect fills the entire screen
	if has_node("BackgroundColor"):
		var background = $BackgroundColor
		background.rect_min_size = get_viewport_rect().size

func save_settings():
	# Save your settings here
	settings.set_value("graphics", "background_color", background_color.to_html())
	var sound_volume = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	settings.set_value("audio", "sound_volume", sound_volume)
	var err = settings.save("user://settings.cfg")
	if err != OK:
		print("Failed to save settings: ", err)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		# This will run for mobile platforms when the back button is pressed
		handle_back_action()

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Default action for Escape key
		# This will run on PC when the Escape key is pressed
		handle_back_action()
		# Make sure to consume the event so it doesn't propagate further
		event.set_echo(false)
		get_tree().set_input_as_handled()

func handle_back_action():
	print("Back action triggered")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
