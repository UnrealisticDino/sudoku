#SudokuSolver
extends Node

var filled_grid_script = preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FilledGrid.gd")

func has_empty_cells(candidates: Array) -> bool:
	for row in candidates:
		for cell in row:
			if cell.size() == 0:
				return true
	return false

var techniques = [
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FullHouse.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedSingles.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenSingles.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedPairs.gd"), #May not work as expected
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenPairs.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedTriples.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenTriples.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedQuads.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenQuads.gd"),
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/PointingPairs.gd"),
				]

func solve_sudoku(grid):
	var filled_grid_instance = filled_grid_script.new()
	var progress_made = true
	var iteration_grid = grid.duplicate()
	var candidates = create_candidates_array(iteration_grid)

	while progress_made:
		var original_grid = iteration_grid.duplicate(true)
		var original_candidates = candidates.duplicate(true)

		for i in range(techniques.size()):
			var technique = techniques[i]
			var technique_instance = technique.new()
			candidates = technique_instance.solve(candidates)
			iteration_grid = update_grid_from_candidates(iteration_grid, candidates)

			if has_empty_cells(candidates):
				print("There are empty cells in the candidates array.")

			if has_rule_violations(iteration_grid):
				display_sudoku_grid(original_grid)
				print("\nSudoku has rule violations")
				display_sudoku_grid(iteration_grid)
				print("\nCandidates\n", candidates)
				break

		if iteration_grid == original_grid and candidates == original_candidates:
			progress_made = false

		if all_cells_filled(iteration_grid):
			print("All cells filled")
			if filled_grid_instance.is_valid_sudoku(iteration_grid):
				progress_made = false
				print("Sudoku is valid")

	display_sudoku_grid(grid)
	print(candidates)
	return grid

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

# Function to create an initial candidates array based on the given grid
func create_candidates_array(grid):
	var candidates = []
	for row in range(9):
		var row_candidates = []
		for col in range(9):
			if grid[row][col] == 0:
				# If the cell is empty (0), add all numbers as possible candidates
				row_candidates.append(range(1, 10))
			else:
				# If the cell is filled, add only the filled number as the candidate
				row_candidates.append([grid[row][col]])
		candidates.append(row_candidates)
	return candidates

# Function to check if there are any changes in the candidates array
func candidates_changed(new_candidates, original_candidates) -> bool:
	for row in range(len(new_candidates)):
		for col in range(len(new_candidates[row])):
			if new_candidates[row][col] != original_candidates[row][col]:
				return true
	return false

# Function to update the grid based on the candidates array
func update_grid_from_candidates(grid, candidates):
	for row in range(len(grid)):
		for col in range(len(grid[row])):
			# Check if there's exactly one candidate left for a cell
			if len(candidates[row][col]) == 1:
				# Update the grid with this candidate number
				grid[row][col] = candidates[row][col][0]
	return grid

func display_sudoku_grid(iteration_grid):
	for row in iteration_grid:
		var row_string = ""
		for cell in row:
			row_string += str(cell) + " "
		print(row_string)
