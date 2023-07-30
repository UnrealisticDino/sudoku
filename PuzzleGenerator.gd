# PuzzleGenerator.gd
extends Node

var Global = preload("res://Scripts/Global.gd")

func _ready():
	var grid = generate_sudoku()
	print("Generated Sudoku: ", grid)  # Print the generated Sudoku
	Global.completed_sudoku = grid  # Update the global variable
	print("Global Sudoku: ", Global.completed_sudoku)  # Print the global Sudoku


func generate_sudoku() -> Array:
	var grid = []
	for i in range(9):
		var row = []
		for j in range(9):
			row.append(0)
		grid.append(row)
	fill_diagonal(grid)
	fill_remaining(grid, 0, 3)
	return grid

func fill_diagonal(grid : Array):
	for i in range(0, 9, 3):
		fill_box(grid, i, i)

func fill_box(grid : Array, row : int, col : int):
	var num : Array = shuffle(range(1, 10))
	for i in range(3):
		for j in range(3):
			grid[row+i][col+j] = num.pop_front()

func fill_remaining(grid : Array, i : int, j : int) -> bool:
	if j >= 9 and i < 8:
		i += 1
		j = 0
	if i >= 9 and j >= 9:
		return true
	if i < 3:
		if j < 3:
			j = 3
	elif i < 9-3:
		if j == int(i/3)*3:
			j += 3
	else:
		if j == 9-3:
			i += 1
			j = 0
			if i >= 9:
				return true
	for num in range(1, 10):
		if check_safe(grid, i, j, num):
			grid[i][j] = num
			if fill_remaining(grid, i, j+1):
				return true
			grid[i][j] = 0
	return false

func check_safe(grid : Array, i : int, j : int, num : int) -> bool:
	return not used_in_row(grid, i, num) and not used_in_col(grid, j, num) and not used_in_box(grid, i-i%3, j-j%3, num)

func used_in_row(grid : Array, i : int, num : int) -> bool:
	for x in range(9):
		if grid[i][x] == num:
			return true
	return false

func used_in_col(grid : Array, j : int, num : int) -> bool:
	for x in range(9):
		if grid[x][j] == num:
			return true
	return false

func used_in_box(grid : Array, row : int, col : int, num : int) -> bool:
	for i in range(3):
		for j in range(3):
			if grid[i+row][j+col] == num:
				return true
	return false

func shuffle(array : Array) -> Array:
	var size : int = array.size()
	var res : Array = array.duplicate()
	for i in range(size):
		var rand_i : int = randi() % size
		var temp : int = res[i]
		res[i] = res[rand_i]
		res[rand_i] = temp
	return res
	
func print_grid(grid : Array):
	for i in range(9):
		var row : String = ""
		for j in range(9):
			row += str(grid[i][j]) + " "
		print(row)
