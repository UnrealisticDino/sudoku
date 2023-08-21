#ImageDisplay
extends Sprite

# Preload the sprite sheet
var sprite_sheet = preload("res://DefaultSprites/numbers.png")

# Signal for cell interaction (if needed)
signal cell_clicked

#func _ready():
#	# Check if the sprite sheet loaded correctly
#	match sprite_sheet:
#		null:
#			print("Failed to load sprite sheet")
#		_:
#			print("Sprite sheet loaded successfully")

func set_number(value, source):
	if sprite_sheet:
		var cell_width = sprite_sheet.get_width() / 3
		var cell_height = sprite_sheet.get_height() / 3

		# Define a dictionary to map numbers to their positions in the 3x3 grid
		var number_positions = {
			1: Vector2(0, 0),
			2: Vector2(1, 0),
			3: Vector2(2, 0),
			4: Vector2(0, 1),
			5: Vector2(1, 1),
			6: Vector2(2, 1),
			7: Vector2(0, 2),
			8: Vector2(1, 2),
			9: Vector2(2, 2)
		}

		# Get the position of the number in the sprite sheet
		var position = number_positions[value]
		
		# Calculate the x and y coordinates based on the position
		var x_position = position.x * cell_width
		var y_position = position.y * cell_height
		
		# Set the texture and region_rect to display the correct number
		self.texture = sprite_sheet
		self.region_rect = Rect2(x_position, y_position, cell_width, cell_height)
		self.region_enabled = true
	else:
		print("Sprite sheet not loaded")

	# Set the color based on the source
	if source == "game":
		self.modulate = Color(1, 0, 0)  # Red color for game-placed numbers
	elif source == "player":
		self.modulate = Color(0, 0, 0)  # Default white color for player-placed numbers

func clear_overlay():
	self.region_enabled = false
	self.texture = null

# If you want to detect clicks on the cell
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Check if the click is within the cell's boundaries
		if self.get_rect().has_point(event.position):
			emit_signal("cell_clicked")
			Input.set_input_as_handled()  # Mark the input as handled to stop propagation
