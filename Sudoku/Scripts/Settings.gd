#Settings
extends Panel

# Nodes
onready var easy_button = $Easy
onready var medium_button = $Medium
onready var hard_button = $Hard

# Reference to the Global script
onready var global_script = get_node("/root/Global")

# Config file for saving settings
var config = ConfigFile.new()

# Colors
const SELECTED_COLOR = Color(0.2, 0.5, 0.8)  # Blueish
const UNSELECTED_COLOR = Color(0.5, 0.5, 0.5)  # Grey

# Current difficulty setting
var current_difficulty = "Easy"

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed")
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
			return

func _ready():
	print("Settings scene ready")
	# Load settings when the scene starts
	load_settings()
	
	# Connect the signals
	easy_button.connect("pressed", self, "_on_difficulty_button_pressed", ["Easy"])
	medium_button.connect("pressed", self, "_on_difficulty_button_pressed", ["Medium"])
	hard_button.connect("pressed", self, "_on_difficulty_button_pressed", ["Hard"])

	# Set initial button colors
	update_button_colors()

func _on_highlight_identical_digits_toggled(enabled):
	# Save the highlight identical digits setting
	config.set_value("highlight", "identical_digits", enabled)
	config.save("user://settings.cfg")

func _on_difficulty_button_pressed(selected_difficulty):
	current_difficulty = selected_difficulty
	# Save the selected difficulty in the config file
	config.set_value("difficulty", "selected", current_difficulty)
	config.save("user://settings.cfg")
	# Update button colors
	update_button_colors()

func update_button_colors():
	# Reset all buttons to unselected color
	easy_button.modulate = UNSELECTED_COLOR
	medium_button.modulate = UNSELECTED_COLOR
	hard_button.modulate = UNSELECTED_COLOR
	
	# Set the selected button to the selected color
	match current_difficulty:
		"Easy":
			easy_button.modulate = SELECTED_COLOR
		"Medium":
			medium_button.modulate = SELECTED_COLOR
		"Hard":
			hard_button.modulate = SELECTED_COLOR

func load_settings():
	# Load settings from the config file
	var err = config.load("user://settings.cfg")
	if err == OK:
		current_difficulty = config.get_value("difficulty", "selected", "Easy")  # Default to "Easy" if not found
		update_button_colors()
