extends CheckBox

var config = ConfigFile.new()  # Initialize config as a new instance of ConfigFile
var special_puzzles_enabled = false

func _ready():
	# Load settings when the checkbox is created
	var error = config.load("user://settings.cfg")
	if error == OK:
		special_puzzles_enabled = config.get_value("game", "special_puzzles_enabled", false)
		set_pressed(special_puzzles_enabled)
	else:
		print("Error loading settings: ", error)

	connect("toggled", self, "_on_CheckBox_toggled")

func _on_CheckBox_toggled(button_pressed):
	special_puzzles_enabled = button_pressed
	print("Special puzzles enabled: ", special_puzzles_enabled)

	# Set the new value in the ConfigFile
	config.set_value("game", "special_puzzles_enabled", special_puzzles_enabled)

	# Save to a file
	var error = config.save("user://settings.cfg")
	if error != OK:
		print("Error saving settings: ", error)
