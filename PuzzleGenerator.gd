#PuzzleGenerator
extends Node

func generate_full_grid():
	var grid = []
	for row in range(9):
		var row_data = []
		for col in range(9):
			row_data.append(0)
		grid.append(row_data)
	# Fill the diagonal 3x3 subgrids
	for i in range(0, 9, 3):
		fill_subgrid(grid, i, i)
	# Fill the remaining cells
	solve_grid(grid)

	return grid

func fill_subgrid(grid, row, col):
	var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	numbers.shuffle()
	for i in range(3):
		for j in range(3):
			grid[row + i][col + j] = numbers.pop_front()

func solve_grid(grid):
	var empty_cell = find_empty_cell(grid)
	if empty_cell == null:
		return true # Puzzle is solved

	var row = empty_cell[0]
	var col = empty_cell[1]

	for num in range(1, 10):
		if is_safe_to_place_number(grid, row, col, num):
			grid[row][col] = num
			if solve_grid(grid):
				return true # Continue if the solution is found
			grid[row][col] = 0 # Backtrack if no solution is found

	return false # Trigger backtracking

func find_empty_cell(grid):
	for row in range(9):
		for col in range(9):
			if grid[row][col] == 0:
				return [row, col]
	return null

func is_safe_to_place_number(grid, row, col, num):
	# Check row, column, and 3x3 subgrid
	for x in range(9):
		if grid[row][x] == num or grid[x][col] == num or grid[row - row % 3 + int(x / 3)][col - col % 3 + x % 3] == num:
			return false
	return true

func generate_puzzle(grid, clues):
	var puzzle = []
	for row in grid:
		puzzle.append(row.duplicate())
	var cells_to_remove = 81 - clues
	while cells_to_remove > 0:
		var row = randi() % 9
		var col = randi() % 9
		if puzzle[row][col] != 0:
			puzzle[row][col] = 0
			cells_to_remove -= 1
	return puzzle
