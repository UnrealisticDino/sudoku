# PuzzleCreator.gd
extends Node
var Global = preload("res://Scripts/Global.gd")

func _ready():
	var grid = Global.completed_sudoku.duplicate()  # Get a copy of the completed Sudoku puzzle
	remove_numbers(grid)
	print_grid(grid)

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
