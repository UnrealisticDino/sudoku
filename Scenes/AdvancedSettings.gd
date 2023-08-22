#AdvancedSettings
extends Panel

# Reference to the ColorPicker node
onready var highlight_color_picker = $HighlightColorPicker
onready var selected_cell_preview = $SelectedCellPreview
onready var identical_cell_preview = $IdenticalCellPreview

# Config file to save and load settings
var config = ConfigFile.new()

func _ready():
	# Load the saved color when the scene is loaded
	config.load("user://settings.cfg")
	var saved_color_html = config.get_value("highlight", "color", "#8080FF")  # Default to blueish color if not found
	highlight_color_picker.color = saved_color_html
	
	# Connect the color_changed signal to a function
	highlight_color_picker.connect("color_changed", self, "_on_highlight_color_changed")

func _on_highlight_color_changed(new_color):
	# Save the selected color to the config file
	config.set_value("highlight", "color", new_color.to_html())
	config.save("user://settings.cfg")
	
	# Update the global variable for the selected color
	Global.selected_cell_color = new_color
	Global.identical_digits_color = new_color.linear_interpolate(Color(0.5, 0.5, 1, 0.5), 0.5)  # Derived color with added transparency
	# Update the preview panels
	selected_cell_preview.modulate = new_color
	identical_cell_preview.modulate = new_color.linear_interpolate(Color(0.5, 0.5, 1, 0.5), 0.5)  # Derived color with added transparency
	Global.save_selected_cell_color(new_color)
