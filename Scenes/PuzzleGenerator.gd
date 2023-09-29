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
func generate_puzzle(filled_sudoku):
	var puzzle = filled_sudoku.duplicate()
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
		print("not last ", puzzle)
		# Send the puzzle to SudokuSolver for validation
		var is_valid = SudokuSolver.solve(puzzle.duplicate(), filled_sudoku.duplicate())
		print("is valid ", is_valid)
		# Restore the cell value if the puzzle is not valid
		if not is_valid:
			print("made it")
			puzzle[row][col] = backup
		
		attempts += 1
	
	# Send the finished puzzle using send_grid function
	send_grid(puzzle)
