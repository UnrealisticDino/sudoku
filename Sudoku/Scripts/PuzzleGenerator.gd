#PuzzleGenerator
extends Node

var GRID_SIZE = 9
var SudokuSolver = preload("res://Sudoku/Scripts/SudokuSolver.gd").new()

# Function to receive the filled Sudoku from Global.gd
func receive_completed_grid(grid):
	var _puzzle = generate_puzzle(grid)

# Function to send the generated puzzle to the appropriate part of your code
func send_grid(grid):
	Global.fetch_grid(grid)

# This function generates a puzzle
func generate_puzzle(filled_sudoku_original):
	var filled_sudoku = deep_copy_2d_array(filled_sudoku_original)
	var puzzle = deep_copy_2d_array(filled_sudoku)
	var GRID_SIZE = 9  # Assuming a 9x9 grid

	# Decide which strategy to use
	var strategy = randi() % 5  # 0: Random, 1: Block-based, 2: Row-based, 3: Diagonal, 4: Patterns

	# Create a list of all cell coordinates
	var all_cells = []
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			all_cells.append({"row": row, "col": col})

	if strategy == 0:  # Random
		all_cells.shuffle()
	elif strategy == 1:  # Block-based
		all_cells.sort_custom(self, "block_based_sort")
	elif strategy == 2:  # Row-based
		all_cells.sort_custom(self, "row_based_sort")
	elif strategy == 3:  # Diagonal-based
		all_cells.sort_custom(self, "diagonal_based_sort")
	elif strategy == 4:  # Patterns like X, cross, etc.
		all_cells.sort_custom(self, "pattern_based_sort")

	# Iterate over each cell in the shuffled/sorted list
	for cell in all_cells:
		var row = cell["row"]
		var col = cell["col"]

		# Skip if the cell is already empty
		if puzzle[row][col] == 0:
			continue

		# Backup the cell value and clear it
		var backup = puzzle[row][col]
		puzzle[row][col] = 0

		# Send the puzzle to SudokuSolver for validation
		var is_valid = SudokuSolver.solve(deep_copy_2d_array(puzzle), deep_copy_2d_array(filled_sudoku), "PuzzleGenerator")

		# Restore the cell value if the puzzle is not valid
		if not is_valid:
			puzzle[row][col] = backup

	# Send the finished puzzle using send_grid function
	send_grid(puzzle)

# Block-based sort
func block_based_sort(a, b):
	var block_a = (a["row"] / 3) * 3 + a["col"] / 3
	var block_b = (b["row"] / 3) * 3 + b["col"] / 3
	return block_a < block_b

# Row-based sort
func row_based_sort(a, b):
	return a["row"] < b["row"]

# Diagonal-based sort
func diagonal_based_sort(a, b):
	var dist_a = abs(a["row"] - a["col"])
	var dist_b = abs(b["row"] - b["col"])
	return dist_a < dist_b

# Pattern-based sort (e.g., X pattern)
func pattern_based_sort(a, b):
	var is_a_on_diag = a["row"] == a["col"] or a["row"] == GRID_SIZE - 1 - a["col"]
	var is_b_on_diag = b["row"] == b["col"] or b["row"] == GRID_SIZE - 1 - b["col"]
	if is_a_on_diag and is_b_on_diag:
		return 0
	elif is_a_on_diag:
		return -1
	elif is_b_on_diag:
		return 1
	else:
		return 0

func deep_copy_2d_array(arr):
	var new_arr = []
	for row in arr:
		new_arr.append(row.duplicate())
	return new_arr
