#ImageDisplay
extends Sprite

func set_number(value):
	if self.texture == null:
		print("Texture is null, attempting to load sprite sheet...")
		self.texture = preload("res://DefaultImages/numbers.jpg")  # Replace with the correct path to your sprite sheet
		if self.texture == null:
			print("Failed to load sprite sheet")
			return
		else:
			print("Sprite sheet loaded successfully")
	
	var cell_width = self.texture.get_width() / 3
	var cell_height = self.texture.get_height() / 3

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
	
	# Set the region_rect to display the correct number
	self.region_rect = Rect2(x_position, y_position, cell_width, cell_height)
	self.region_enabled = true

func clear_overlay():
	self.region_enabled = false
	self.texture = null
