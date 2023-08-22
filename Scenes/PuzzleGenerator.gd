#PuzzleGenerator
extends Node

var difficulty = "Easy"  # Default difficulty

# This function generates a puzzle based on the provided difficulty.
func generate_puzzle(difficulty):
	var puzzle = _create_base_puzzle()  # Create a base solved puzzle
	puzzle = _remove_numbers_based_on_difficulty(puzzle, difficulty)
	return puzzle

# Create a base solved puzzle
func _create_base_puzzle():
	var grid = []
	for row in range(9):
		var row_data = []
		for col in range(9):
			row_data.append(0)
		grid.append(row_data)
	# Fill the diagonal 3x3 subgrids
	for i in range(0, 9, 3):
		_fill_subgrid(grid, i, i)
	# Fill the remaining cells
	_solve_grid(grid)
	return grid

# Fill a 3x3 subgrid
func _fill_subgrid(grid, row, col):
	var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	numbers.shuffle()
	for i in range(3):
		for j in range(3):
			grid[row + i][col + j] = numbers.pop_front()

# Solve the grid
func _solve_grid(grid):
	var empty_cell = _find_empty_cell(grid)
	if empty_cell == null:
		return true # Puzzle is solved

	var row = empty_cell[0]
	var col = empty_cell[1]

	for num in range(1, 10):
		if _is_safe_to_place_number(grid, row, col, num):
			grid[row][col] = num
			if _solve_grid(grid):
				return true
			grid[row][col] = 0

	return false

# Find an empty cell in the grid
func _find_empty_cell(grid):
	for row in range(9):
		for col in range(9):
			if grid[row][col] == 0:
				return [row, col]
	return null

# Check if it's safe to place a number in the specified cell
func _is_safe_to_place_number(grid, row, col, num):
	for x in range(9):
		if grid[row][x] == num or grid[x][col] == num or grid[row - row % 3 + int(x / 3)][col - col % 3 + x % 3] == num:
			return false
	return true

# Remove numbers from the puzzle based on difficulty
func _remove_numbers_based_on_difficulty(puzzle, difficulty):
	var clues = 0
	match difficulty:
		"Easy":
			clues = 35
		"Medium":
			clues = 25
		"Hard":
			clues = 20

	var cells_to_remove = 81 - clues
	while cells_to_remove > 0:
		var row = randi() % 9
		var col = randi() % 9
		if puzzle[row][col] != 0:
			puzzle[row][col] = 0
			cells_to_remove -= 1

	return puzzle
