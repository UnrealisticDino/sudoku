#Cell
extends LineEdit

# Define the signal
signal cell_selected

func _ready():
	connect("gui_input", self, "_on_LineEdit_gui_input") # Updated method name
	var connections = get_signal_connection_list("gui_input")

func _on_LineEdit_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("cell_selected", self)
