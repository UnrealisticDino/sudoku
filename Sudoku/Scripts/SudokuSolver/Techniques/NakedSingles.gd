#NakedSingles.gd
extends Node

# Function to solve naked singles in a Sudoku grid
func solve(grid: Array) -> Array:
	print("NakedSingles")
	var updated = false
	var possibilities = Array()

	# Initialize an array to store possible numbers for each cell
	for i in range(9):
		possibilities.append([])
		for j in range(9):
			possibilities[i].append([])

	# Iterate over each cell in the grid
	for row in range(9):
		for col in range(9):
			# Skip if the cell is already filled
			if grid[row][col] != 0:
				continue

			# Determine possible numbers for the current cell
			for num in range(1, 10):
				if is_num_possible(grid, row, col, num):
					possibilities[row][col].append(num)

			# If there's only one possibility, it's a naked single
			if possibilities[row][col].size() == 1:
				grid[row][col] = possibilities[row][col][0]
				updated = true

	# Return just the grid as per updated solver script format
	return grid

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
