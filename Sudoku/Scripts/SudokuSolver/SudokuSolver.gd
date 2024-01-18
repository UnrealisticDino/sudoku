#SudokuSolver
extends Node

var filled_grid_script = preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FilledGrid.gd")

var techniques = [
				
				
				
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenQuads.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedQuads.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenTriples.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedTriples.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenPairs.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedPairs.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenSingles.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedSingles.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FullHouse.gd"),
				]

func solve_sudoku(grid):
	var filled_grid_instance = filled_grid_script.new()
	var progress_made = true
	var iteration_grid = grid.duplicate()

	while progress_made:
		var original_grid = iteration_grid.duplicate(true)
		#print(original_grid)

		for i in range(techniques.size()):
			var technique = techniques[i]
			var technique_instance = technique.new()
			iteration_grid = technique_instance.solve(iteration_grid)
			if has_rule_violations(iteration_grid):
				display_sudoku_grid(original_grid)
				print("has a rule violation")
				display_sudoku_grid(iteration_grid)
				break

		if iteration_grid == original_grid:
			progress_made = false

		if all_cells_filled(iteration_grid):
			var filled_grid = filled_grid_script.new()
			if filled_grid.is_valid_sudoku(iteration_grid):
				progress_made = false
				print("Sudoku is valid")

	if is_sudoku_solved(grid, filled_grid_instance):
		print("Sudoku Solved: ", grid)
	else:
		print("Sudoku could not be fully solved with current techniques.", grid)

	return grid

func is_sudoku_solved(grid, filled_grid_instance):
	# Use the passed instance of FilledGrid
	if filled_grid_instance.is_valid_sudoku(grid):
		return true
	else:
		return false

func all_cells_filled(puzzle):
	for row in puzzle:
		for cell in row:
			if cell == 0:
				return false
	return true

func has_rule_violations(board: Array) -> bool:
	for i in range(9):
		var row_values = []
		var col_values = []
		var box_values = []

		for j in range(9):
			# Check row
			if board[i][j] != 0:
				if board[i][j] in row_values:
					return true
				row_values.append(board[i][j])

			# Check column
			if board[j][i] != 0:
				if board[j][i] in col_values:
					return true
				col_values.append(board[j][i])

			# Check 3x3 box
			var row_index = 3 * (i / 3) + j / 3
			var col_index = 3 * (i % 3) + j % 3
			if board[row_index][col_index] != 0:
				if board[row_index][col_index] in box_values:
					return true
				box_values.append(board[row_index][col_index])

	return false

func display_sudoku_grid(iteration_grid):
	for row in iteration_grid:
		var row_string = ""
		for cell in row:
			row_string += str(cell) + " "
		print(row_string)
