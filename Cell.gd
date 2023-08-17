#Cell
extends LineEdit

# Signal emitted when the cell is selected
signal cell_selected

# Called when the node enters the scene tree for the first time
func _ready():
	# Connect the text_changed signal of the LineEdit (self) to a local function
	self.connect("text_changed", self, "_on_LineEdit_text_changed")
	
	# Connect the focus_entered signal to detect when the LineEdit is clicked on
	self.connect("focus_entered", self, "_on_LineEdit_focus_entered")

# Called when the LineEdit gains focus (i.e., when it's clicked on)
func _on_LineEdit_focus_entered():
	print("LineEdit focus entered")
	emit_signal("cell_selected", self)

# Handle user input for the cell
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

# Called when the content of the LineEdit changes
func _on_LineEdit_text_changed(new_text):
	# Access the ImageDisplay node directly
	var image_display = self.get_parent().get_node("ImageDisplay")
	
	# If the cell now has a number, set the overlay to match the number
	if new_text != "":
		image_display.set_number(int(new_text))
	else:
		image_display.clear_overlay()
