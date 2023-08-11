# HighlightIdenticalDigits.gd
extends CheckBox

func _ready():
	connect("toggled", self, "_on_CheckBox_toggled")

func _on_CheckBox_toggled(button_pressed):
	Global.highlight_identical_digits = button_pressed # Access the Singleton's variable
	print("Highlight identical digits:", Global.highlight_identical_digits) # Debugging print statement
