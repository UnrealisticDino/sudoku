#ImageDisplay
extends Sprite

# Width and height of each individual cell in the sprite sheet
var cell_width = self.texture.get_width() / 3
var cell_height = self.texture.get_height() / 3

func set_number(value):
	# Define a dictionary to map numbers to their positions in the 3x3 grid
	var number_positions = {
		3: Vector2(0, 0),
		8: Vector2(1, 0),
		4: Vector2(2, 0),
		5: Vector2(0, 1),
		1: Vector2(1, 1),
		9: Vector2(2, 1),
		7: Vector2(0, 2),
		6: Vector2(1, 2),
		2: Vector2(2, 2)
	}

	# Get the position of the number in the sprite sheet
	var position = number_positions[value]
	
	# Calculate the x and y coordinates based on the position
	var x_position = position.x * cell_width
	var y_position = position.y * cell_height
	
	# Set the region_rect to display the correct number
	self.region_rect = Rect2(x_position, y_position, cell_width, cell_height)
	self.region_enabled = true
