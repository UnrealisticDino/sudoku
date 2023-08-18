#Cell
extends Button

signal cell_selected(cell)

var cell_value = "" setget set_cell_value
var editable_by_player = true

func _pressed():
	if editable_by_player:
		emit_signal("cell_selected", self)

func set_cell_value(value):
	cell_value = value
	text = value

# Convert a Unicode value to its corresponding character string
func unicode_to_char(unicode_value):
	return "%c" % unicode_value

func _ready():
	# Connect the button's pressed signal to set it as the focused cell
	connect("pressed", self, "_on_CellButton_pressed")

func _on_CellButton_pressed():
	# Set this button as the focused cell
	grab_focus()

func _input(event):
	if not editable_by_player:
		return  # Exit the function early if editing is not allowed

	if event is InputEventKey and event.pressed:
		var key = event.scancode
		if key >= KEY_1 and key <= KEY_9:
			cell_value = str(key - KEY_1 + 1)  # Update the cell_value
			self.text = cell_value  # Update the button's displayed text
