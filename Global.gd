extends Node

var highlight_identical_digits = false

func _ready():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		highlight_identical_digits = config.get_value("settings", "highlight_identical_digits", false) # Default to false if not found

func toggle_highlight(value):
	highlight_identical_digits = value
	print("Highlight identical digits:", highlight_identical_digits) # Debugging print statement

const GENERATED_COLOR = Color(0.5, 0.5, 0.5)  # Gray color for generated numbers
const PLAYER_COLOR = Color(1, 1, 1)  # White color for player numbers
