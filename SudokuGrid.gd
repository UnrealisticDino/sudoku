#SudokuGrid
extends GridContainer

var selected_cell = null

func _ready():
	randomize()
	for i in range(81):
		var cell = LineEdit.new()
		cell.max_length = 1 # Limit input to one character
		cell.connect("mouse_entered", self, "_on_Cell_mouse_entered", [cell])
		cell.set("editable_by_player", true) # Add custom property
		add_child(cell)
	
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
	# Return the cells in the specified row
	var cells = []
	for i in range(9):
		cells.append(get_child(row * 9 + i).text)
	return cells

func get_cells_in_column(col):
	# Return the cells in the specified column
	var cells = []
	for i in range(9):
		cells.append(get_child(i * 9 + col).text)
	return cells

func get_cells_in_subgrid(subgrid):
	# Return the cells in the specified 3x3 subgrid
	var cells = []
	var row_offset = int(subgrid / 3) * 3
	var col_offset = (subgrid % 3) * 3
	for row in range(3):
		for col in range(3):
			cells.append(get_child((row + row_offset) * 9 + (col + col_offset)).text)
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
	var index = 0
	for row in range(9):
		for col in range(9):
			var cell = get_child(index)
			if cell is LineEdit:
				var value = puzzle[row][col]
				cell.text = str(value) if value != 0 else ""
				var is_editable_by_player = value == 0
				cell.set("editable_by_player", is_editable_by_player) # Set custom property
				cell.editable = is_editable_by_player # Disable or enable editing
			index += 1
