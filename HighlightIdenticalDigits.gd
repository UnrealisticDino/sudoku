# HighlightIdenticalDigits.gd
extends CheckBox

func _ready():
	connect("toggled", self, "_on_CheckBox_toggled")

func _on_CheckBox_toggled(button_pressed):
	Global.highlight_identical_digits = button_pressed
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("settings", "highlight_identical_digits", button_pressed)
	config.save("user://settings.cfg")
