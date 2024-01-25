#SudokuSolver.gd
extends Node

var filled_grid_script = preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FilledGrid.gd")

var techniques = [
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/FullHouse.gd"),			#1
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedSingles.gd"),		#2
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenSingles.gd"),   	#3
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedPairs.gd"),			#4
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenPairs.gd"),			#5
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedTriples.gd"),		#6
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenTriples.gd"),		#7
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/NakedQuads.gd"),			#8
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/HiddenQuads.gd"),			#9
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/PointingPairs.gd"),		#10
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/PointingTriples.gd"),		#11
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/BoxLineReduction.gd"),	#12
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/LockedCandidates.gd"),	#13
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/XWing.gd"),				#14
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/Swordfish.gd"),			#15
				preload("res://Sudoku/Scripts/SudokuSolver/Techniques/Jellyfish.gd"),			#16
				]

func solve_sudoku(grid, difficulty):
	print(difficulty)
	var filled_grid_instance = filled_grid_script.new()
	var progress_made = true
	var iteration_grid = grid.duplicate()
	var candidates = create_candidates_array(iteration_grid)

	# Define difficulty levels and their associated techniques
	var difficulty_techniques = {
		"Easy": [0, 1, 2],  # FullHouse, NakedSingles, HiddenSingles
		"Medium": [0, 1, 2, 3, 4],  # Add NakedPairs and HiddenPairs
		"Hard": [0, 1, 2, 3, 4, 5, 6],  # Add NakedTriples and HiddenTriples
		# Add more difficulty levels as needed
	}

	var available_techniques = techniques  # Default to all techniques
	if difficulty in difficulty_techniques:
		available_techniques = []
		for index in difficulty_techniques[difficulty]:
			available_techniques.append(techniques[index])

	while progress_made:
		var original_grid = iteration_grid.duplicate(true)
		var original_candidates = candidates.duplicate(true)

		for i in range(available_techniques.size()):
			var technique = available_techniques[i]
			var technique_instance = technique.new()
			candidates = technique_instance.solve(candidates)
			iteration_grid = update_grid_from_candidates(iteration_grid, candidates)

			if has_empty_cells(candidates):
				print("There are empty cells in the candidates array.")

			if has_rule_violations(iteration_grid):
				print("\nSudoku has rule violations")
				display_sudoku_grid(iteration_grid)
				print("\nCandidates\n", candidates)
				break

		if iteration_grid == original_grid and candidates == original_candidates:
			progress_made = false

		if all_cells_filled(iteration_grid):
#			display_sudoku_grid(grid)
#			print("All cells filled")
			if filled_grid_instance.is_valid_sudoku(iteration_grid):
				progress_made = false
				print("Sudoku is valid")

	if difficulty == "" or difficulty == "null":
#		print("Difficulty was null or empty")
		return grid
	else:
		return true

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
				# If the cell is empty (0), calculate possible candidates
				var possible_candidates = []
				for num in range(1, 10):
					if is_valid_candidate(grid, row, col, num):
						possible_candidates.append(num)
				row_candidates.append(possible_candidates)
			else:
				# If the cell is filled, add only the filled number as the candidate
				row_candidates.append([grid[row][col]])
		candidates.append(row_candidates)
	return candidates

# Function to check if a number is a valid candidate for a cell
func is_valid_candidate(grid, row, col, num):
	# Check the row
	for i in range(9):
		if grid[row][i] == num:
			return false
	
	# Check the column
	for i in range(9):
		if grid[i][col] == num:
			return false
	
	# Check the 3x3 subgrid
	var start_row = row - row % 3
	var start_col = col - col % 3
	for i in range(3):
		for j in range(3):
			if grid[start_row + i][start_col + j] == num:
				return false
	
	return true

func has_empty_cells(candidates: Array) -> bool:
	for row in candidates:
		for cell in row:
			if cell.size() == 0:
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
