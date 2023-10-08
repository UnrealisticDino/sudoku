#PuzzleGenerator
extends Node

var GRID_SIZE = 9
var SudokuSolver = preload("res://Scenes/SudokuSolver.gd").new()

# Function to receive the filled Sudoku from Global.gd
func receive_completed_grid(grid):
	var puzzle = generate_puzzle(grid)

# Function to send the generated puzzle to the appropriate part of your code
func send_grid(grid):
	Global.fetch_grid(grid)

# This function generates a puzzle
func generate_puzzle(filled_sudoku_original):
	var filled_sudoku = deep_copy_2d_array(filled_sudoku_original)
	var puzzle = deep_copy_2d_array(filled_sudoku)
	var GRID_SIZE = 9  # Assuming a 9x9 grid

	# Create a list of all cell coordinates
	var all_cells = []
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			all_cells.append({"row": row, "col": col})

	# Shuffle the list to randomize the order
	all_cells.shuffle()

	# Iterate over each cell in the shuffled list
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
		var is_valid = SudokuSolver.solve(deep_copy_2d_array(puzzle), deep_copy_2d_array(filled_sudoku))

		# Restore the cell value if the puzzle is not valid
		if not is_valid:
			puzzle[row][col] = backup

	# Send the finished puzzle using send_grid function
	send_grid(puzzle)

func deep_copy_2d_array(arr):
	var new_arr = []
	for row in arr:
		new_arr.append(row.duplicate())
	return new_arr
