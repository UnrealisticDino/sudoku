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
	var attempts = 0
	
	while attempts < 100:  # You can adjust the number of attempts
		var row = randi() % GRID_SIZE
		var col = randi() % GRID_SIZE
		
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
		attempts += 1
	
	# Send the finished puzzle using send_grid function
	send_grid(puzzle)

func deep_copy_2d_array(arr):
	var new_arr = []
	for row in arr:
		new_arr.append(row.duplicate())
	return new_arr
