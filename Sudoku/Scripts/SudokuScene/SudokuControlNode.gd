#SudokuControlNode.gd
extends Control

var settings = ConfigFile.new()
var last_orientation = OS.get_screen_orientation()
var background_color = Global.background_color
var last_screen_size = OS.get_window_size()

func _ready():
	load_settings()
	adjust_to_screen_orientation()

func _process(_delta):
	var current_screen_size = OS.get_window_size()
	if current_screen_size != last_screen_size:
		if (current_screen_size.x > current_screen_size.y and last_screen_size.x <= last_screen_size.y) or (current_screen_size.x < current_screen_size.y and last_screen_size.x >= last_screen_size.y):
			print("Orientation changed")
			adjust_to_screen_orientation()
		last_screen_size = current_screen_size

func adjust_to_screen_orientation():
	var screen_size = OS.get_window_size()
	var is_landscape = screen_size.x > screen_size.y
#	if is_landscape:
#		layout_for_landscape()
#	else:
#		layout_for_portrait()
	last_orientation = OS.get_screen_orientation()

#func layout_for_landscape():
#	var menu_landscape = $MenuLandscape
#	menu_landscape.visible = true
#
#	var menu_portrait = $MenuPortrait
#	menu_portrait.visible = false
#
#func layout_for_portrait():
#	var menu_portrait = $MenuPortrait
#	menu_portrait.visible = true
#
#	var menu_landscape = $MenuLandscape
#	menu_landscape.visible = false

func load_settings():
	# Load your settings here
	var err = settings.load("user://settings.cfg")
	if err == OK:
		# If settings loaded successfully, apply them
		background_color = Global.background_color
		update_background_size()
	else:
		background_color = settings.get_value("graphics", "background_color", Color(0.5, 0.5, 0.5))
		update_background_size()

func update_background_size():
	# This ensures the ColorRect fills the entire screen
	if has_node("BackgroundPortrait"):
		var background = $BackgroundPortrait
		background.rect_min_size = get_viewport_rect().size

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed")
		get_tree().change_scene("res://Scenes/StartGame.tscn")
		
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/StartGame.tscn")
			return
