# PuzzleCreator.gd
extends Node

func _ready():
	var grid = load_sudoku_from_memory()  # Get a copy of the completed Sudoku puzzle
	remove_numbers(grid)
	print_grid(grid)

func load_sudoku_from_memory():
	return Global.completed_sudoku.duplicate()  # Return a copy of the completed Sudoku puzzle

func get_puzzle() -> Array:
	var grid = load_sudoku_from_memory()
	remove_numbers(grid)
	return grid

func remove_numbers(grid : Array):
	var count : int
	match Global.difficulty:  # Use Global.difficulty
		"easy":
			count = 20
		"medium":
			count = 30
		"hard":
			count = 40
	while count > 0:
		var cell_id : int = randi() % 81
		var i : int = int(cell_id/9)
		var j : int = cell_id%9
		if grid[i][j] != 0:
			count -= 1
			grid[i][j] = 0

func print_grid(grid : Array):
	for i in range(9):
		var row : String = ""
		for j in range(9):
			row += str(grid[i][j]) + " "
		print(row)
