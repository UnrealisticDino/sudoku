extends LineEdit

# Define the signal
signal cell_selected

func _ready():
	print("test")
	# Connect the mouse_entered signal to a method that will emit the cell_selected signal
	connect("mouse_entered", self, "_on_mouse_entered")

func _on_mouse_entered():
	print("hellotest")
	# Emit the cell_selected signal when the mouse enters the cell
	emit_signal("cell_selected", self)
