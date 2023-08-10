#Settings
extends Panel

# Nodes
onready var highlight_identical_digits_checkbox = $VBoxContainer/HighlightIdenticalDigits

# Config file for saving settings
var config = ConfigFile.new()

func _ready():
	# Load settings when the scene starts
	load_settings()
	
	# Connect the signal inside the _ready function
	highlight_identical_digits_checkbox.connect("toggled", self, "_on_highlight_identical_digits_toggled")

func _on_highlight_identical_digits_toggled(enabled):
	# Save the highlight identical digits setting
	config.set_value("highlight", "identical_digits", enabled)
	config.save("user://settings.cfg")

func load_settings():
	# Load settings from the config file
	var err = config.load("user://settings.cfg")
	if err == OK:
		highlight_identical_digits_checkbox.pressed = config.get_value("highlight", "identical_digits", true)  # Default to true if not found
