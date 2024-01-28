#FilledGrid.gd
extends Node

# Sudoku validation function
func is_valid_sudoku(puzzle):
	# Check if rows, columns, and 3x3 squares are valid
	for i in range(9):
		if not is_valid_row(puzzle, i) or not is_valid_column(puzzle, i) or not is_valid_square(puzzle, i):
			return false
	return true

# Check if a row is valid
func is_valid_row(puzzle, row):
	var seen = []
	for cell in puzzle[row]:
		if cell == 0 or (cell in seen and cell != 0):
			return false
		seen.append(cell)
	return true

# Check if a column is valid
func is_valid_column(puzzle, col):
	var seen = []
	for row in range(9):
		var cell = puzzle[row][col]
		if cell == 0 or (cell in seen and cell != 0):
			return false
		seen.append(cell)
	return true

# Check if a 3x3 square is valid
func is_valid_square(puzzle, square):
	var seen = []
	for row in range(square / 3 * 3, square / 3 * 3 + 3):
		for col in range(square % 3 * 3, square % 3 * 3 + 3):
			var cell = puzzle[row][col]
			if cell == 0 or (cell in seen and cell != 0):
				return false
			seen.append(cell)
	return true
