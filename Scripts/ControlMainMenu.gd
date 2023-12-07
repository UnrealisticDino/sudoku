# MainMenu.gd
extends Control

var settings = ConfigFile.new()
var last_orientation = OS.get_screen_orientation()
var background_color = Color(1, 1, 1) # Default to white
var last_screen_size = OS.get_window_size()

func _ready():
	var screen_size = OS.get_screen_size()
	OS.set_window_size(screen_size)
	var viewport = get_tree().root
	viewport.size = screen_size
	viewport.connect("size_changed", self, "_on_screen_resized")
	_on_screen_resized()
	last_orientation = OS.get_screen_orientation()
	load_settings()
	adjust_to_screen_orientation()

func _on_screen_resized():
	var screen_size = OS.get_window_size()
	var is_landscape = screen_size.x > screen_size.y

	var viewport = get_tree().root
	viewport.size = screen_size  # Adjust the viewport size to the current window size.

	update_background_size()  # Ensure the background fills the new size.

func setup_background():
	var background = ColorRect.new()
	background.color = background_color
	background.name = "BackgroundColor"
	add_child(background)
	background.rect_min_size = get_viewport_rect().size
	background.anchor_right = 1
	background.anchor_bottom = 1
	move_child(background, 0)

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
	if is_landscape:
		layout_for_landscape()
		setup_background()
	else:
		layout_for_portrait()
		setup_background()
	last_orientation = OS.get_screen_orientation()

func layout_for_landscape():
	var menu_landscape = $MenuLandscape
	menu_landscape.visible = true

	var menu_portrait = $MenuPortrait
	menu_portrait.visible = false

func layout_for_portrait():
	# Assuming you have a Control node for menu items in portrait orientation
	var menu_portrait = $MenuPortrait
	menu_portrait.visible = true
	# Assuming you have a Control node for menu items in landscape orientation
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
		get_tree().quit()

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F4 and event.alt:
			get_tree().quit()  # Ensure this line exists to allow Alt+F4 to work
		elif event.scancode == KEY_ESCAPE:
			# ... Some other code for handling ESCAPE
			pass
