#ButtonThemeManager
extends Button

var grid_lines_color = Global.grid_lines_color
var player_digit_color = Global.player_digit_color
var selected_cell_color = Global.selected_cell_color
var button_bg_color = Global.button_bg_color

var custom_theme = Theme.new()

func _ready():
	update_button_theme()
	apply_theme_to_existing_buttons()
	get_tree().connect("node_added", self, "_on_node_added")

func update_button_theme():
	var outline_width = 2  # Change this value to increase or decrease the thickness

	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = button_bg_color
	style_normal.border_color = grid_lines_color
	style_normal.border_width_left = outline_width
	style_normal.border_width_top = outline_width
	style_normal.border_width_right = outline_width
	style_normal.border_width_bottom = outline_width

	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = button_bg_color
	style_hover.border_color = grid_lines_color
	style_hover.border_width_left = outline_width
	style_hover.border_width_top = outline_width
	style_hover.border_width_right = outline_width
	style_hover.border_width_bottom = outline_width

	var style_pressed = StyleBoxFlat.new()
	style_pressed.bg_color = selected_cell_color  # Selected cell color for pressed state
	style_pressed.border_color = grid_lines_color
	style_pressed.border_width_left = outline_width
	style_pressed.border_width_top = outline_width
	style_pressed.border_width_right = outline_width
	style_pressed.border_width_bottom = outline_width

	var style_focus = StyleBoxFlat.new()
	style_focus.bg_color = Color(0, 0, 0, 0)
	style_focus.border_color = grid_lines_color
	style_focus.border_width_left = outline_width
	style_focus.border_width_top = outline_width
	style_focus.border_width_right = outline_width
	style_focus.border_width_bottom = outline_width

	# Apply styles to the custom_theme for each state
	custom_theme.set_stylebox("normal", "Button", style_normal)
	custom_theme.set_stylebox("hover", "Button", style_hover)
	custom_theme.set_stylebox("pressed", "Button", style_pressed)
	custom_theme.set_stylebox("focus", "Button", style_focus)

	# Set font color overrides for the custom theme
	custom_theme.set_color("font_color", "Button", player_digit_color)
	custom_theme.set_color("font_color_hover", "Button", player_digit_color)
	custom_theme.set_color("font_color_pressed", "Button", player_digit_color)
	custom_theme.set_color("font_color_focus", "Button", player_digit_color)

func apply_theme_to_existing_buttons():
	# Apply the custom_theme to all existing buttons in the scene
	var root_node = get_tree().get_root()
	_apply_theme_to_buttons(root_node)

func _apply_theme_to_buttons(node):
	if node is Button:
		node.set_theme(custom_theme)
	for child in node.get_children():
		_apply_theme_to_buttons(child)

func _on_node_added(node):
	if node is Button:
		node.set_theme(custom_theme)
