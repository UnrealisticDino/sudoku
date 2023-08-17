#SudokuGrid
extends GridContainer
var selected_cell = null

func _ready():
	randomize()
	var subgrid_scene = preload("res://Subgrid.tscn") # Load the Subgrid scene
	for i in range(9):
		var subgrid_container = Control.new()
		subgrid_container.rect_min_size = Vector2(190, 190) # Set the size of the container, including padding
		var subgrid = subgrid_scene.instance() # Instantiate the Subgrid scene
		subgrid_container.add_child(subgrid) # Add the subgrid to the container
		add_child(subgrid_container) # Add the container to the main grid
		for j in range(subgrid.get_child_count()):
			var cell_instance = subgrid.get_child(j) # Get the Cell instance
			var line_edit = cell_instance.get_node("LineEdit") # Get the LineEdit node inside the Cell
			line_edit.connect("cell_selected", self, "_on_Cell_selected")
		if (i + 1) % 3 == 0 and i < 8: # Add spacer after every 3 subgrids
			var spacer = Control.new()
			spacer.rect_min_size = Vector2(10, 0) # Set the size of the spacer
			add_child(spacer)

	# Create an instance of the PuzzleGenerator scene
	var puzzle_generator_scene = preload("res://PuzzleGenerator.tscn")
	var puzzle_generator = puzzle_generator_scene.instance()

	# Generate the full grid and create a puzzle with clues
	var full_grid = puzzle_generator.generate_full_grid()
	var clues = 30 # Adjust this number for different difficulty levels
	var puzzle = puzzle_generator.generate_puzzle(full_grid, clues)

	# Display the puzzle on the grid
	display_puzzle(puzzle)

func _input(event):
	if event is InputEventKey and event.pressed:
		var key = event.scancode
		if key >= KEY_1 and key <= KEY_9 and selected_cell != null:
			if selected_cell.get("editable_by_player"): # Check custom property
				var number = key - KEY_1 + 1
				if is_valid_input(selected_cell, number):
					selected_cell.text = str(number)
					update_game_state(selected_cell, number)

func update_game_state(cell, number):
	# Update the game state based on the selected cell and input number
	# You can add logic here to check for a win condition, update scores, etc.
	pass

func _on_Cell_selected(line_edit):
	# Update the selected_cell variable
	selected_cell = line_edit
	
	# Access the ImageDisplay node, which is a sibling of the LineEdit node
	var image_display = line_edit.get_node("../ImageDisplay")
	
	# Check the content of the LineEdit and update the ImageDisplay accordingly
	if line_edit.text == "":
		print("Selected cell is empty")
		image_display.clear_overlay()
	else:
		print("Selected cell has value:", line_edit.text)
		image_display.set_number(int(line_edit.text))

func highlight_identical_cells(digit):
	print("Highlighting cells with digit:", digit)
	for i in range(get_child_count()):
		var subgrid_container = get_child(i)
		if subgrid_container is Control and subgrid_container.get_child_count() > 0:
			var subgrid = subgrid_container.get_child(0) # Get the Subgrid instance
			for j in range(subgrid.get_child_count()):
				var cell_instance = subgrid.get_child(j)
				var line_edit = cell_instance.get_node("LineEdit")
				if line_edit.text == str(digit): # Make sure to compare with the string representation of the digit
					print("Highlighting cell with text:", line_edit.text)
					line_edit.set("custom_colors/font_color", Color(1, 0, 0)) # Example: change font color to red

func is_valid_input(cell, number):
	var index = -1
	for i in range(get_child_count()):
		if get_child(i) == cell:
			index = i
			break
	if index == -1:
		return false # Cell not found
	var row = int(index / 9)
	var col = index % 9
	var subgrid = int(row / 3) * 3 + int(col / 3)
	# Check if the number is already present in the same row
	if str(number) in get_cells_in_row(row):
		return false
	# Check if the number is already present in the same column
	if str(number) in get_cells_in_column(col):
		return false
	# Check if the number is already present in the same subgrid
	if str(number) in get_cells_in_subgrid(subgrid):
		return false
	return true

func _on_Cell_content_changed(cell, new_text):
	# Access the ImageDisplay node inside the Cell instance
	var image_display = cell.get_node("ImageDisplay")
	
	# If the cell now has a number, set the overlay to match the number
	if new_text != "":
		image_display.set_number(int(new_text))
	else:
		image_display.clear_overlay()

func get_cells_in_row(row):
	var cells = []
	for i in range(9):
		var subgrid_index = int(row / 3) * 3 + int(i / 3)
		var subgrid_container = get_child(subgrid_index)
		var subgrid = subgrid_container.get_child(0)
		var cell = subgrid.get_child((row % 3) * 3 + (i % 3))
		cells.append(cell.text)
	return cells

func get_cells_in_column(col):
	var cells = []
	for i in range(9):
		var subgrid_index = int(i / 3) * 3 + int(col / 3)
		var subgrid_container = get_child(subgrid_index)
		var subgrid = subgrid_container.get_child(0)
		var cell = subgrid.get_child((i % 3) * 3 + (col % 3))
		cells.append(cell.text)
	return cells

func get_cells_in_subgrid(subgrid_index):
	var cells = []
	var row_offset = int(subgrid_index / 3) * 3
	var col_offset = (subgrid_index % 3) * 3
	for row in range(3):
		for col in range(3):
			var inner_subgrid_index = row_offset + int(row / 3)
			var subgrid_container = get_child(inner_subgrid_index)
			var subgrid = subgrid_container.get_child(0)
			var cell = subgrid.get_child((row % 3) * 3 + (col % 3))
			cells.append(cell.text)
	return cells

func display_puzzle(puzzle):
	for row in range(9):
		for col in range(9):
			# Calculate the subgrid's container index and the cell's name based on its position in the grid
			var subgrid_container_index = int(row / 3) * 4 + int(col / 3)  # Adjusted to account for spacers
			var cell_name = "Cell" + str(row % 3 * 3 + col % 3 + 1)  # This will give names from Cell1 to Cell9
			
			# Get the specific subgrid container and then the subgrid instance
			var subgrid_container = get_child(subgrid_container_index)
			var subgrid_instance = subgrid_container.get_child(0)  # Assuming the subgrid is the first child of the container
			
			# Get the specific cell instance
			var cell_instance = subgrid_instance.get_node(cell_name)
			
			# Access the LineEdit inside the Cell instance
			var line_edit = cell_instance.get_node("LineEdit")
			
			# Display the puzzle values and set the editable property
			if puzzle[row][col] != 0:
				line_edit.text = str(puzzle[row][col])
				line_edit.editable = false  # Numbers placed by the game are not editable
			else:
				line_edit.text = ""
				line_edit.editable = true  # Empty cells are editable by the player
				
			# Update the ImageDisplay based on the content of the LineEdit
			update_image_display_for_cell(cell_instance)

# Additional function to update the ImageDisplay based on the content of a LineEdit
func update_image_display_for_cell(cell):
	var line_edit = cell.get_node("LineEdit")
	var image_display = cell.get_node("ImageDisplay")
	if line_edit.text == "":
		image_display.clear_overlay()
	else:
		image_display.set_number(int(line_edit.text))
