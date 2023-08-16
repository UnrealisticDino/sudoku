#Cell
extends LineEdit

# Define the signal
signal cell_selected

func _ready():
	connect("gui_input", self, "_on_Cell_input")
	connect("text_changed", self, "_on_Cell_input")

func _on_Cell_input(event = null):
	# Handle mouse input
	if event and event is InputEventMouseButton and event.pressed:
		emit_signal("cell_selected", self)

	# Handle text change
	var image_display = get_node("../ImageDisplay")
	if self.text == "":
		image_display.clear_overlay()
	else:
		image_display.set_number(int(self.text))
