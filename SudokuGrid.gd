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
		if (i + 1) % 3 == 0 and i < 8: # Add spacer after every 3 subgrids
			var spacer = Control.new()
			spacer.rect_min_size = Vector2(10, 0) # Set the size of the spacer
			add_child(spacer)
	var full_grid = generate_full_grid()
	var clues = 30 # Adjust this number for different difficulty levels
	var puzzle = generate_puzzle(full_grid, clues)
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

func generate_full_grid():
	var grid = []
	for row in range(9):
		var row_data = []
		for col in range(9):
			row_data.append(0)
		grid.append(row_data)
	# Fill the diagonal 3x3 subgrids
	for i in range(0, 9, 3):
		fill_subgrid(grid, i, i)

	# Fill the remaining cells
	solve_grid(grid)

	return grid

func fill_subgrid(grid, row, col):
	var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	numbers.shuffle()
	for i in range(3):
		for j in range(3):
			grid[row + i][col + j] = numbers.pop_front()

func solve_grid(grid):
	var empty_cell = find_empty_cell(grid)
	if empty_cell == null:
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

func find_empty_cell(grid):
	for row in range(9):
		for col in range(9):
			if grid[row][col] == 0:
				return [row, col]
	return null

func is_safe_to_place_number(grid, row, col, num):
	# Check row, column, and 3x3 subgrid
	for x in range(9):
		if grid[row][x] == num or grid[x][col] == num or grid[row - row % 3 + int(x / 3)][col - col % 3 + x % 3] == num:
			return false
	return true

func generate_puzzle(grid, clues):
	var puzzle = []
	for row in grid:
		puzzle.append(row.duplicate())
	var cells_to_remove = 81 - clues
	while cells_to_remove > 0:
		var row = randi() % 9
		var col = randi() % 9
		if puzzle[row][col] != 0:
			puzzle[row][col] = 0
			cells_to_remove -= 1
	return puzzle

func display_puzzle(puzzle):
	for row in range(9):
		for col in range(9):
			var subgrid_container_index = row / 3 * 4 + col / 3  # Adjusted to account for spacers
			var cell_index = row % 3 * 3 + col % 3
			
			var subgrid = get_child(subgrid_container_index)
			var cell_container = subgrid.get_child(cell_index)
			if cell_container == null:
				print("Error: Cell container not found in subgrid at index:", cell_index)
				continue

			var cell_instance = cell_container.get_node("Cell")  # Get the Cell instance
			if cell_instance == null:
				print("Error: Cell instance not found in cell container.")
				continue

			var cell = cell_instance.get_node("LineEdit")  # Access the LineEdit inside the Cell instance
			if cell == null:
				print("Error: LineEdit not found in cell instance.")
				continue

			cell.text = str(puzzle[row][col]) if puzzle[row][col] != 0 else ""
