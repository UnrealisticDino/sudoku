#AdvancedSettings
extends Panel

# Reference to the ColorPicker node
onready var highlight_color_picker = $HighlightColorPicker
onready var selected_cell_preview = $SelectedCellPreview
onready var identical_cell_preview = $IdenticalCellPreview

onready var player_digit_color = $PlayerDigits
onready var game_placed_digit_color = $GamePlacedDigits
onready var grid_lines_color = $GameGrid

# Config file to save and load settings
var config = ConfigFile.new()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed")
		get_tree().change_scene("res://Scenes/Settings.tscn")
		
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/Settings.tscn")
			return

func _ready():
	# Load the saved colors when the scene is loaded
	config.load("user://settings.cfg")
	
	# Load saved colors into the color pickers if they exist in the config file
	if config.has_section_key("highlight", "color"):
		highlight_color_picker.color = Color(config.get_value("highlight", "color"))
	if config.has_section_key("player_digit", "color"):
		player_digit_color.color = Color(config.get_value("player_digit", "color"))
	if config.has_section_key("game_placed_digit", "color"):
		game_placed_digit_color.color = Color(config.get_value("game_placed_digit", "color"))
	if config.has_section_key("grid_color", "color"):
		grid_lines_color.color = Color(config.get_value("grid_color", "color"))

	# Connect the color_changed signal to functions for the new color pickers
	highlight_color_picker.connect("color_changed", self, "_on_highlight_color_changed")
	player_digit_color.connect("color_changed", self, "_on_player_digit_color_changed")
	game_placed_digit_color.connect("color_changed", self, "_on_game_placed_digit_color_changed")
	grid_lines_color.connect("color_changed", self, "_on_game_grid_color_changed")

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

func _on_player_digit_color_changed(new_color):
	# Save the selected color to the config file
	config.set_value("player_digit", "color", new_color.to_html())
	config.save("user://settings.cfg")
	
	# Update the global variable for the player_digit color
	Global.player_digit_color = new_color

func _on_game_placed_digit_color_changed(new_color):
	# Save the selected color to the config file
	config.set_value("game_placed_digit", "color", new_color.to_html())
	config.save("user://settings.cfg")
	
	# Update the global variable for the game_placed_digit color
	Global.game_placed_digit_color = new_color

func _on_game_grid_color_changed(new_color):
		# Save the selected color to the config file
	config.set_value("grid_color", "color", new_color.to_html())
	config.save("user://settings.cfg")
	
	# Update the global variable for the game_placed_digit color
	Global.grid_lines_color = new_color
