#HiddenSingles.gd
extends Node

# Function to solve Hidden Singles in a Sudoku grid
func solve(grid: Array) -> Array:
	print("HiddenSingles")
	var updated = false

	# Check each row, column, and box for Hidden Singles
	for i in range(9):
		if _check_hidden_singles_unit(grid, i, true) or _check_hidden_singles_unit(grid, i, false) or _check_hidden_singles_box(grid, i):
			updated = true

	return grid

# Helper function to check and fill Hidden Singles in a row or column
func _check_hidden_singles_unit(grid: Array, index: int, is_row: bool) -> bool:
	for num in range(1, 10):
		var count = 0
		var last_possible_cell = Vector2()
		for i in range(9):
			var cell_value = grid[index][i] if is_row else grid[i][index]
			if cell_value == 0 and is_num_possible(grid, index, i, num, is_row):
				last_possible_cell = Vector2(index, i) if is_row else Vector2(i, index)
				count += 1
			if count > 1:
				break
		if count == 1:
			grid[int(last_possible_cell.x)][int(last_possible_cell.y)] = num
			return true
	return false

# Helper function to check and fill Hidden Singles in a 3x3 box
func _check_hidden_singles_box(grid: Array, box: int) -> bool:
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	for num in range(1, 10):
		var count = 0
		var last_possible_cell = Vector2()
		for i in range(3):
			for j in range(3):
				var cell_row = start_row + i
				var cell_col = start_col + j
				if grid[cell_row][cell_col] == 0 and is_num_possible(grid, cell_row, cell_col, num, true):
					last_possible_cell = Vector2(cell_row, cell_col)
					count += 1
				if count > 1:
					break
			if count > 1:
				break
		if count == 1:
			grid[int(last_possible_cell.x)][int(last_possible_cell.y)] = num
			return true
	return false

# Helper function to check if a number can be placed in a specific cell
func is_num_possible(grid: Array, row: int, col: int, num: int, check_box: bool) -> bool:
	# Check row and column
	for i in range(9):
		if grid[row][i] == num or grid[i][col] == num:
			return false

	# Check 3x3 subgrid
	if check_box:
		var start_row = (row / 3) * 3
		var start_col = (col / 3) * 3
		for i in range(start_row, start_row + 3):
			for j in range(start_col, start_col + 3):
				if grid[i][j] == num:
					return false

	return true
