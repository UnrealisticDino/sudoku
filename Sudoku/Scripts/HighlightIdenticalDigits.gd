# HighlightIdenticalDigits.gd
extends CheckBox

func _ready():
	# Connect the toggled signal
	connect("toggled", self, "_on_CheckBox_toggled")
	
	# Load the saved setting
	load_setting()

func _on_CheckBox_toggled(button_pressed):
	Global.highlight_identical_digits = button_pressed
	save_setting(button_pressed)

func load_setting():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	# Check if the file was loaded successfully and the setting exists
	if err == OK and config.has_section_key("settings", "highlight_identical_digits"):
		var saved_value = config.get_value("settings", "highlight_identical_digits", false)
		self.pressed = saved_value
		Global.highlight_identical_digits = saved_value

func save_setting(value):
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("settings", "highlight_identical_digits", value)
	config.save("user://settings.cfg")
