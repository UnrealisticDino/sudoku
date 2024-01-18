#HiddenPairs.gd
extends Node

# Function to solve Hidden Pairs in a Sudoku grid
func solve(grid: Array) -> Array:
	print("HiddenPairs")
	var updated = false

	# Check each row, column, and box for Hidden Pairs
	for i in range(9):
		if _check_hidden_pairs_unit(grid, i, true) or _check_hidden_pairs_unit(grid, i, false) or _check_hidden_pairs_box(grid, i):
			updated = true

	return grid

# Helper function to check and resolve Hidden Pairs in a row or column
func _check_hidden_pairs_unit(grid: Array, index: int, is_row: bool) -> bool:
	var updated = false
	var possibilities

	# Choose the appropriate function based on whether it's a row or a column
	if is_row:
		possibilities = _get_possibilities_for_row(grid, index)
	else:
		possibilities = _get_possibilities_for_col(grid, index)

	# Iterate through the possibilities
	for num1 in range(1, 10):
		var cells_with_num1 = []
		for cell in possibilities[num1 - 1]:
			cells_with_num1.append(cell)
		if cells_with_num1.size() == 2:
			# Check for a second number that also appears only in these two cells
			for num2 in range(num1 + 1, 10):
				var cells_with_num2 = []
				for cell in possibilities[num2 - 1]:
					cells_with_num2.append(cell)
				if cells_with_num2 == cells_with_num1:
					# Found a hidden pair, now eliminate other numbers from these two cells
					for cell in cells_with_num1:
						updated = _reduce_to_hidden_pair(grid, cell.x, cell.y, [num1, num2]) or updated
	return updated

# Helper function to check and resolve Hidden Pairs in a 3x3 box
func _check_hidden_pairs_box(grid: Array, box: int) -> bool:
	var updated = false
	var start_row = (box / 3) * 3
	var start_col = (box % 3) * 3
	var possibilities = _get_possibilities_for_box(grid, start_row, start_col)

	# Find hidden pairs in the possibilities
	for num1 in range(1, 10):
		var cells_with_num1 = []
		for i in range(3):
			for j in range(3):
				var row = start_row + i
				var col = start_col + j
				if num1 in possibilities[3 * i + j]:
					cells_with_num1.append(Vector2(row, col))
		if cells_with_num1.size() == 2:
			# Check for a second number that also appears only in these two cells
			for num2 in range(num1 + 1, 10):
				var cells_with_num2 = []
				for i in range(3):
					for j in range(3):
						var row = start_row + i
						var col = start_col + j
						if num2 in possibilities[3 * i + j]:
							cells_with_num2.append(Vector2(row, col))
				if cells_with_num2 == cells_with_num1:
					# Found a hidden pair, now eliminate other numbers from these two cells
					for cell in cells_with_num1:
						updated = _reduce_to_hidden_pair(grid, cell.x, cell.y, [num1, num2]) or updated
	return updated

func _get_possibilities_for_row(grid: Array, row: int) -> Array:
	var possibilities = []
	for num in range(1, 10):  # Start from 1 to 9, corresponding to Sudoku numbers
		possibilities.append([])

	for col in range(9):  # Iterate through each column
		if grid[row][col] == 0:  # Check if the cell is empty
			for num in range(1, 10):  # Check for each number from 1 to 9
				if not _check_number_in_row(grid, row, num) and not _check_number_in_col(grid, col, num) and not _check_number_in_box(grid, row, col, num):
					possibilities[num - 1].append(Vector2(row, col))  # Use num - 1 as index
	return possibilities

func _get_possibilities_for_col(grid: Array, col: int) -> Array:
	var possibilities = []
	for num in range(1,10):
		possibilities.append([])

	for row in range(9):
		if grid[row][col] == 0:
			for num in range(1, 10):
				if not _check_number_in_row(grid, row, num) and not _check_number_in_col(grid, col, num) and not _check_number_in_box(grid, row, col, num):
					possibilities[num - 1].append(Vector2(row, col))
	return possibilities

func _get_possibilities_for_box(grid: Array, start_row: int, start_col: int) -> Array:
	var possibilities = []
	for num in range(1, 10):
		possibilities.append([])

	for i in range(3):
		for j in range(3):
			var row = start_row + i
			var col = start_col + j
			if grid[row][col] == 0:
				for num in range(1, 10):
					if not _check_number_in_row(grid, row, num) and not _check_number_in_col(grid, col, num) and not _check_number_in_box(grid, row, col, num):
						possibilities[num - 1].append(Vector2(row, col))
	return possibilities

# Helper function to reduce a cell's possibilities to a hidden pair
func _reduce_to_hidden_pair(grid: Array, row: int, col: int, pair: Array) -> bool:
	var updated = false
	var cell_possibilities = grid[row][col]

	# Ensure the cell is an array of possibilities and not a fixed number
	if typeof(cell_possibilities) == TYPE_ARRAY:
		# Remove all possibilities that are not part of the hidden pair
		var new_possibilities = []
		for number in pair:
			if number in cell_possibilities:
				new_possibilities.append(number)
		
		# Update the cell's possibilities if they are different
		if new_possibilities.size() != cell_possibilities.size():
			grid[row][col] = new_possibilities
			updated = true

	return updated

# Helper function to check if a number is present in a row
func _check_number_in_row(grid: Array, row: int, num: int) -> bool:
	for col in range(9):
		if grid[row][col] == num:
			return true
	return false

# Helper function to check if a number is present in a column
func _check_number_in_col(grid: Array, col: int, num: int) -> bool:
	for row in range(9):
		if grid[row][col] == num:
			return true
	return false

# Helper function to check if a number is present in a 3x3 box
func _check_number_in_box(grid: Array, row: int, col: int, num: int) -> bool:
	var start_row = (row / 3) * 3
	var start_col = (col / 3) * 3
	for i in range(3):
		for j in range(3):
			if grid[start_row + i][start_col + j] == num:
				return true
	return false
