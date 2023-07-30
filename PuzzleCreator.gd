# PuzzleCreator.gd
extends Node

func _ready():
	var grid = load_sudoku_from_file()  # Get a copy of the completed Sudoku puzzle
	remove_numbers(grid)
	print_grid(grid)

func load_sudoku_from_file():
	var grid = []
	var file = File.new()
	if file.file_exists("res://completed_sudoku.txt"):
		file.open("res://completed_sudoku.txt", File.READ)
		while not file.eof_reached():
			var line = file.get_line()
			var row = []
			for num in line.split(" "):
				if num != "":
					row.append(int(num))
			grid.append(row)
		file.close()
	return grid


func remove_numbers(grid : Array):
	var count : int
	print("Global.difficulty: ", Global.difficulty)
	match Global.difficulty:  # Use Global.difficulty
		"easy":
			count = 20
		"medium":
			count = 30
		"hard":
			count = 40
	print("Count: ", count)
	while count > 0:
		var cell_id : int = randi() % 81
		var i : int = int(cell_id/9)
		var j : int = cell_id%9
		if grid[i][j] != 0:
			count -= 1
			grid[i][j] = 0
			print("Removed number at (", i, ", ", j, ")")

func print_grid(grid : Array):
	for i in range(9):
		var row : String = ""
		for j in range(9):
			row += str(grid[i][j]) + " "
		print(row)
