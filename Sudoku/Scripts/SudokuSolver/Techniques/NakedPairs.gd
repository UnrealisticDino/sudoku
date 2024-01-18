#NakedPairs.gd
extends Node

# Function to solve Naked Pairs in a Sudoku grid
func solve(grid: Array) -> Array:
	print("NakedPairs")
	var updated = false

	# Check each row, column, and box for Naked Pairs
	for i in range(9):
		if _check_naked_pairs_unit(grid, i, true) or _check_naked_pairs_unit(grid, i, false) or _check_naked_pairs_box(grid, i):
			updated = true

	return grid

# Helper function to check and eliminate Naked Pairs in a row or column
func _check_naked_pairs_unit(grid: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var possibilities = _get_possibilities_for_unit(grid, index, is_row)

	# Check for naked pairs in the possibilities
	for i in range(8):
		for j in range(i + 1, 9):
			if possibilities[i].size() == 2 and possibilities[i] == possibilities[j]:
				# Found a naked pair, eliminate these numbers from other cells in the unit
				for k in range(9):
					if k != i and k != j:
						var cell_row = index if is_row else k
						var cell_col = k if is_row else index
						updated = _eliminate_possibilities(grid, cell_row, cell_col, possibilities[i]) or updated
	return updated

# Helper function to check and eliminate Naked Pairs in a 3x3 box
func _check_naked_pairs_box(grid: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	var possibilities = _get_possibilities_for_box(grid, start_row, start_col)

	# Check for naked pairs in the possibilities
	for i in range(8):
		for j in range(i + 1, 9):
			if possibilities[i].size() == 2 and possibilities[i] == possibilities[j]:
				# Found a naked pair, eliminate these numbers from other cells in the box
				for k in range(9):
					if k != i and k != j:
						var cell_row = start_row + (k / 3)
						var cell_col = start_col + (k % 3)
						updated = _eliminate_possibilities(grid, cell_row, cell_col, possibilities[i]) or updated
	return updated

# Helper function to get possibilities for each cell in a unit (row, column, or box)
func _get_possibilities_for_unit(grid: Array, index: int, is_row: bool) -> Array:
	var possibilities = Array()
	for i in range(9):
		if is_row and grid[index][i] != 0:
			possibilities.append([])
		elif not is_row and grid[i][index] != 0:
			possibilities.append([])
		else:
			var cell_possibilities = _calculate_cell_possibilities(grid, index if is_row else i, i if is_row else index)
			possibilities.append(cell_possibilities)
	return possibilities

func _get_possibilities_for_box(grid: Array, start_row: int, start_col: int) -> Array:
	var possibilities = Array()
	for i in range(3):
		for j in range(3):
			var row = start_row + i
			var col = start_col + j
			if grid[row][col] != 0:
				possibilities.append([])
			else:
				var cell_possibilities = _calculate_cell_possibilities(grid, row, col)
				possibilities.append(cell_possibilities)
	return possibilities

# Helper function to calculate the possibilities for a cell
func _calculate_cell_possibilities(grid: Array, row: int, col: int) -> Array:
	var possibilities = []
	for num in range(1, 10):
		if is_num_possible(grid, row, col, num):
			possibilities.append(num)
	return possibilities

# Helper function to check if a number can be placed in a specific cell
func is_num_possible(grid: Array, row: int, col: int, num: int) -> bool:
	# Check row and column
	for i in range(9):
		if grid[row][i] == num or grid[i][col] == num:
			return false

	# Check 3x3 subgrid
	var start_row = (row / 3) * 3
	var start_col = (col / 3) * 3
	for i in range(start_row, start_row + 3):
		for j in range(start_col, start_col + 3):
			if grid[i][j] == num:
				return false

	return true

# Helper function to eliminate possibilities from a cell
func _eliminate_possibilities(grid: Array, row: int, col: int, numbers_to_eliminate: Array) -> bool:
	var updated = false

	# Check if the cell at grid[row][col] is an array (i.e., has multiple candidates)
	if typeof(grid[row][col]) == TYPE_ARRAY:
		for number in numbers_to_eliminate:
			if number in grid[row][col]:
				grid[row][col].erase(number)
				updated = true

	return updated
