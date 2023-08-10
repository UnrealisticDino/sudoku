#SudokuGrid
extends GridContainer
var selected_cell = null

onready var puzzle_generator = preload("res://PuzzleGenerator.tscn").instance()

func _ready():
	randomize()
	
	# Load the Subgrid scene and instantiate it multiple times for the Sudoku grid
	var subgrid_scene = preload("res://Subgrid.tscn")
	for i in range(9):
		var subgrid_container = Control.new()
		subgrid_container.rect_min_size = Vector2(190, 190) # Set the size of the container, including padding
		var subgrid = subgrid_scene.instance() # Instantiate the Subgrid scene
		subgrid_container.add_child(subgrid) # Add the subgrid to the container
		add_child(subgrid_container) # Add the container to the main grid
		if (i + 1) % 3 == 0 and i < 8: # Add spacer after every 3 subgrids
			var spacer = Control.new()
			spacer.rect_min_size = Vector2(10, 0) # Set the size of the spacer
			add_child(spacer)
	
	# Use the puzzle_generator to generate the puzzle
	var full_grid = puzzle_generator.generate_full_grid()
	var clues = 30 # Adjust this number for different difficulty levels
	var puzzle = puzzle_generator.generate_puzzle(full_grid, clues)
	display_puzzle(puzzle)
	
	# Connect the selected signal from each cell to the _on_Cell_selected function
	for i in range(get_child_count()):
		var subgrid_container = get_child(i)
		var subgrid = subgrid_container.get_child(0)
		for j in range(subgrid.get_child_count()):
			var cell = subgrid.get_child(j)
			cell.connect("selected", self, "_on_Cell_selected")

func _input(event):
	if event is InputEventKey and event.pressed:
		var key = event.scancode
		if key >= KEY_1 and key <= KEY_9 and selected_cell != null:
			if selected_cell.get("editable_by_player"): # Check custom property
				var number = key - KEY_1 + 1
				if is_valid_input(selected_cell, number):
					selected_cell.text = str(number)
					update_game_state(selected_cell, number)

func _on_Cell_mouse_entered(cell):
	selected_cell = cell
	
func update_game_state(cell, number):
	# Check if the Sudoku puzzle is solved
	if validate_sudoku():
		print("Congratulations! You've solved the puzzle!")
		
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

func _on_Cell_text_changed(cell, new_text):
	new_text = str(new_text)
	if new_text != "" and (int(new_text) < 1 or int(new_text) > 9):
		cell.text = ""
		
func validate_sudoku():
	# Check rows
	for row in range(9):
		if not validate_group(get_cells_in_row(row)):
			return false
	# Check columns
	for col in range(9):
		if not validate_group(get_cells_in_column(col)):
			return false
	# Check 3x3 subgrids
	for subgrid in range(9):
		if not validate_group(get_cells_in_subgrid(subgrid)):
			return false
	return true

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

func validate_group(cells):
	# Check that the cells contain no duplicate numbers
	var numbers = []
	for cell in cells:
		if cell != "" and cell in numbers:
			return false
		elif cell != "":
			numbers.append(cell)
	return true

	var row = empty_cell[0]
	var col = empty_cell[1]

	for num in range(1, 10):
		if is_safe_to_place_number(grid, row, col, num):
			grid[row][col] = num
			if solve_grid(grid):
				return true
			grid[row][col] = 0

	return false

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
