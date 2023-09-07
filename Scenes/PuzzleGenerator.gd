#PuzzleGenerator
extends Node
var difficulty = "Easy"
var GRID_SIZE = 9
var SUBGRID_SIZE = 3
var temp_puzzle = []
var max_removed_digits = 100
var current_difficulty = "Easy"
var possible_numbers_grid = []

func initialize_possible_numbers_grid():
	for i in range(GRID_SIZE):
		var row = []
		for j in range(GRID_SIZE):
			row.append([1, 2, 3, 4, 5, 6, 7, 8, 9])
		possible_numbers_grid.append(row)

var config = ConfigFile.new()
func load_settings():
	# Load settings from the config file
	var err = config.load("user://settings.cfg")
	if err == OK:
		current_difficulty = config.get_value("difficulty", "selected", "Easy")  # Default to "Easy" if not found

# Function to receive the filled Sudoku from Global.gd
func receive_completed_grid(grid):
	load_settings()
	difficulty = current_difficulty
	print("Current Difficulty is ",current_difficulty)
	var puzzle = generate_puzzle(grid, difficulty)

func send_grid(grid):
	Global.fetch_grid(grid)

# This function generates a puzzle based on the difficulty's techniques.
func generate_puzzle(filled_sudoku, difficulty):
	var puzzle = filled_sudoku.duplicate()
	
	# Check if the puzzle is solvable with the given techniques for the difficulty
	if is_solvable_with_techniques(puzzle, difficulty, max_removed_digits):
		return puzzle

func is_solvable_with_techniques(puzzle, difficulty, max_removed_digits):

	if difficulty in difficulty_techniques:
		for technique in difficulty_techniques[difficulty]:
			match technique:
				#Needed
				"use_full_house":
					use_full_house = true
				"use_naked_singles":
					use_naked_singles = true
				#Basic
				"use_hidden_singles":
					use_hidden_singles = true
				#Medium
				"use_naked_pairs":
					use_naked_pairs = true
				"use_hidden_pairs":
					use_hidden_pairs = true
				"use_naked_triples":
					use_naked_triples = true
				"use_hidden_triples":
					use_hidden_triples = true
				"use_naked_quads":
					use_naked_quads = true
				"use_hidden_quads":
					use_hidden_quads = true
				"use_pointing_pairs":
					use_pointing_pairs = true
				"use_pointing_triples":
					use_pointing_triples = true
				"use_box_line_reduction":
					use_box_line_reduction = true
				"use_locked_candidates":
					use_locked_candidates = true
				"use_x_wing":
					use_x_wing = true
				#Advanced
				"use_swordfish":
					use_swordfish = true
				"use_jellyfish":
					use_jellyfish = true
				"use_simple_coloring":
					use_simple_coloring = true
				"use_xyz_wing":
					use_xyz_wing = true
				"use_w_wing":
					use_w_wing = true
				"use_skyscraper":
					use_skyscraper = true
				"use_two_string_kite":
					use_two_string_kite = true
				"use_empty_rectangle":
					use_empty_rectangle = true
				"use_unique_rectangles":
					use_unique_rectangles = true
				"use_finned_x_wing":
					use_finned_x_wing = true
				"use_finned_swordfish":
					use_finned_swordfish = true
				"use_finned_jellyfish":
					use_finned_jellyfish = true
				#Expert
				"use_als_xz":
					use_als_xz = true
				"use_als_xy_wing":
					use_als_xy_wing = true
				"use_death_blossom":
					use_death_blossom = true
				"use_bug":
					use_bug = true
				"use_forcing_chains":
					use_forcing_chains = true
				"use_forcing_nets":
					use_forcing_nets = true
				"use_y_wing_style":
					use_y_wing_style = true
				"use_remote_pairs":
					use_remote_pairs = true
				"use_grouped_x_cycles":
					use_grouped_x_cycles = true
				"use_3d_medusa":
					use_3d_medusa = true
	# Start a loop to iteratively remove digits and check solvability
	var GRID_SIZE = puzzle.size()  # Assuming puzzle is a square grid
	var digits_removed = 0
	var tried_cells = []

	while true:
		var row = randi() % GRID_SIZE
		var col = randi() % GRID_SIZE
		if Vector2(row, col) in tried_cells:  # If the cell has already been tried, continue to the next iteration
			continue
		tried_cells.append(Vector2(row, col))  # Add the current cell to the tried list

		if puzzle[row][col] != 0:  # If the cell is not already empty
			var backup_value = puzzle[row][col]
			puzzle[row][col] = 0  # Remove the number

			var was_solvable = false
			# Try to solve the puzzle using all techniques in order
			while not was_solvable:
				#Needed
				if use_full_house and apply_full_house(puzzle, row, col):
					was_solvable = true
				elif use_naked_singles and apply_naked_singles(puzzle, row, col):
					was_solvable = true
				#Basic
				elif use_hidden_singles and apply_hidden_singles(puzzle, row, col):
					was_solvable = true
				#Medium
				elif use_naked_pairs and apply_naked_pairs(puzzle, row, col):
					was_solvable = true
				elif use_naked_triples and apply_naked_triples(puzzle, row, col):
					was_solvable = true
				elif use_hidden_triples and apply_hidden_triples(puzzle, row, col):
					was_solvable = true
				elif use_naked_quads and apply_naked_quads(puzzle, row, col):
					was_solvable = true
				elif use_hidden_quads and apply_hidden_quads(puzzle, row, col):
					was_solvable = true
				elif use_pointing_pairs and apply_pointing_pairs(puzzle, row, col):
					was_solvable = true
				# ... Add other techniques as needed ...

				# If none of the techniques can solve the puzzle, break out of the loop
				if not was_solvable:
					break

			if not was_solvable:
				puzzle[row][col] = backup_value  # Restore the removed number if not solvable by any technique
			else:
				digits_removed += 1

		if tried_cells.size() == GRID_SIZE * GRID_SIZE:
			break

	Global.fetch_grid(puzzle)  # Send the finished puzzle to Global.gd
	return true  # The puzzle is solvable with the given techniques

func apply_full_house(puzzle, row_index, col_index):
	var progress_made = false
	# Check the row of the cleared cell
	var count_empty = 0
	var empty_col = -1
	for j in range(GRID_SIZE):
		if puzzle[row_index][j] == 0:
			count_empty += 1
			empty_col = j
	
	if count_empty == 1:
		# Only one empty cell in the row, find the missing number and fill it in
		var missing_num = find_missing_number(puzzle[row_index])
		progress_made = true

	# Check the column of the cleared cell
	count_empty = 0
	var empty_row = -1
	for i in range(GRID_SIZE):
		if puzzle[i][col_index] == 0:
			count_empty += 1
			empty_row = i
	if count_empty == 1:
		# Only one empty cell in the column, find the missing number and fill it in
		var col_values = []
		for i in range(GRID_SIZE):
				col_values.append(puzzle[i][col_index])

		var missing_num = find_missing_number(col_values)
		progress_made = true

	# Check the block (3x3 square) containing the cleared cell
	var block_row_start = (row_index / SUBGRID_SIZE) * SUBGRID_SIZE
	var block_col_start = (col_index / SUBGRID_SIZE) * SUBGRID_SIZE
	count_empty = 0
	var empty_cell = [-1, -1]
	var block_values = []
	for i in range(SUBGRID_SIZE):
		for j in range(SUBGRID_SIZE):
			var row = block_row_start + i
			var col = block_col_start + j
			block_values.append(puzzle[row][col])
			if puzzle[row][col] == 0:
				count_empty += 1
				empty_cell = [row, col]
	if count_empty == 1:
		# Only one empty cell in the block, find the missing number and fill it in
		var missing_num = find_missing_number(block_values)
		progress_made = true
	return progress_made

func apply_naked_singles(puzzle, row_index, col_index):
	var progress_made = false
	if puzzle[row_index][col_index] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row_index, col_index)
		if possible_numbers.size() == 1:
			progress_made = true
	return progress_made

func apply_hidden_singles(puzzle, row, col):
	var progress_made = false
	var GRID_SIZE = puzzle.size()

	if puzzle[row][col] == 0:  # If the cell is empty
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		for num in possible_numbers:
			if is_hidden_single(puzzle, row, col, num):
				puzzle[row][col] = num
				progress_made = true
				break

	return progress_made

func apply_naked_pairs(puzzle, row, col):
	var GRID_SIZE = puzzle.size()

	# If the cell is empty
	if puzzle[row][col] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		
		# Check if there are exactly 2 possible numbers for the cell
		if possible_numbers.size() == 2:
			# Check the row for another cell with the same two possible numbers
			for j in range(GRID_SIZE):
				if j != col and puzzle[row][j] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, row, j)
					if other_possible_numbers == possible_numbers:
						return true  # Found a naked pair in the row
			
			# Check the column for another cell with the same two possible numbers
			for i in range(GRID_SIZE):
				if i != row and puzzle[i][col] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, i, col)
					if other_possible_numbers == possible_numbers:
						return true  # Found a naked pair in the column
			
			# Check the block for another cell with the same two possible numbers
			var block_row_start = (row / SUBGRID_SIZE) * SUBGRID_SIZE
			var block_col_start = (col / SUBGRID_SIZE) * SUBGRID_SIZE
			for i in range(SUBGRID_SIZE):
				for j in range(SUBGRID_SIZE):
					var r = block_row_start + i
					var c = block_col_start + j
					if (r != row or c != col) and puzzle[r][c] == 0:
						var other_possible_numbers = get_possible_numbers(puzzle, r, c)
						if other_possible_numbers == possible_numbers:
							return true  # Found a naked pair in the block

	return false

func apply_naked_triples(puzzle, row, col):
	var GRID_SIZE = puzzle.size()

	# If the cell is empty
	if puzzle[row][col] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		
		# Check if there are 2 or 3 possible numbers for the cell
		if possible_numbers.size() > 1 and possible_numbers.size() <= 3:
			# Check the row for other cells with 2 or 3 possible numbers that form a naked triple
			var triples_row = [possible_numbers]
			for j in range(GRID_SIZE):
				if j != col and puzzle[row][j] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, row, j)
					if other_possible_numbers.size() > 1 and other_possible_numbers.size() <= 3:
						triples_row.append(other_possible_numbers)
			if triples_row.size() == 3 and union(triples_row).size() == 3:
				return true  # Found a naked triple in the row
			
			# Check the column for other cells with 2 or 3 possible numbers that form a naked triple
			var triples_col = [possible_numbers]
			for i in range(GRID_SIZE):
				if i != row and puzzle[i][col] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, i, col)
					if other_possible_numbers.size() > 1 and other_possible_numbers.size() <= 3:
						triples_col.append(other_possible_numbers)
			if triples_col.size() == 3 and union(triples_col).size() == 3:
				return true  # Found a naked triple in the column
			
			# Check the block for other cells with 2 or 3 possible numbers that form a naked triple
			var block_row_start = int(row / SUBGRID_SIZE) * SUBGRID_SIZE
			var block_col_start = int(col / SUBGRID_SIZE) * SUBGRID_SIZE
			var triples_block = [possible_numbers]
			for i in range(SUBGRID_SIZE):
				for j in range(SUBGRID_SIZE):
					var r = block_row_start + i
					var c = block_col_start + j
					if r != row and c != col and puzzle[r][c] == 0:
						var other_possible_numbers = get_possible_numbers(puzzle, r, c)
						if other_possible_numbers.size() > 1 and other_possible_numbers.size() <= 3:
							triples_block.append(other_possible_numbers)
			if triples_block.size() == 3 and union(triples_block).size() == 3:
				return true  # Found a naked triple in the block

	return false

func apply_hidden_triples(puzzle, row, col):
	var GRID_SIZE = puzzle.size()

	# If the cell is empty
	if puzzle[row][col] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		
		# Check if there are more than 3 possible numbers for the cell
		if possible_numbers.size() > 3:
			return false

		# Check the row for hidden triples
		var candidate_cells_row = []
		for j in range(GRID_SIZE):
			if j != col and puzzle[row][j] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, row, j)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_row.append(other_possible_numbers)
		if check_for_hidden_triple(possible_numbers, candidate_cells_row):
			return true

		# Check the column for hidden triples
		var candidate_cells_col = []
		for i in range(GRID_SIZE):
			if i != row and puzzle[i][col] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, i, col)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_col.append(other_possible_numbers)
		if check_for_hidden_triple(possible_numbers, candidate_cells_col):
			return true

		# Check the block for hidden triples
		var block_row_start = int(row / SUBGRID_SIZE) * SUBGRID_SIZE
		var block_col_start = int(col / SUBGRID_SIZE) * SUBGRID_SIZE
		var candidate_cells_block = []
		for i in range(SUBGRID_SIZE):
			for j in range(SUBGRID_SIZE):
				var r = block_row_start + i
				var c = block_col_start + j
				if (r != row or c != col) and puzzle[r][c] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, r, c)
					if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
						candidate_cells_block.append(other_possible_numbers)
		if check_for_hidden_triple(possible_numbers, candidate_cells_block):
			return true

	return false

func apply_naked_quads(puzzle, row, col):
	var GRID_SIZE = puzzle.size()

	# If the cell is empty
	if puzzle[row][col] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		
		# Check if there are 2, 3, or 4 possible numbers for the cell
		if possible_numbers.size() < 2 or possible_numbers.size() > 4:
			return false

		# Check the row for naked quads
		var candidate_cells_row = []
		for j in range(GRID_SIZE):
			if j != col and puzzle[row][j] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, row, j)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_row.append(other_possible_numbers)
		if check_for_naked_quad(possible_numbers, candidate_cells_row):
			return true

		# Check the column for naked quads
		var candidate_cells_col = []
		for i in range(GRID_SIZE):
			if i != row and puzzle[i][col] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, i, col)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_col.append(other_possible_numbers)
		if check_for_naked_quad(possible_numbers, candidate_cells_col):
			return true

		# Check the block for naked quads
		var block_row_start = int(row / SUBGRID_SIZE) * SUBGRID_SIZE
		var block_col_start = int(col / SUBGRID_SIZE) * SUBGRID_SIZE
		var candidate_cells_block = []
		for i in range(SUBGRID_SIZE):
			for j in range(SUBGRID_SIZE):
				var r = block_row_start + i
				var c = block_col_start + j
				if (r != row or c != col) and puzzle[r][c] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, r, c)
					if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
						candidate_cells_block.append(other_possible_numbers)
		if check_for_naked_quad(possible_numbers, candidate_cells_block):
			return true

	return false

func apply_hidden_quads(puzzle, row, col):
	var GRID_SIZE = puzzle.size()

	# If the cell is empty
	if puzzle[row][col] == 0:
		var possible_numbers = get_possible_numbers(puzzle, row, col)
		
		# Check if there are between 1 and 4 possible numbers for the cell
		if possible_numbers.size() < 1 or possible_numbers.size() > 4:
			return false

		# Check the row for hidden quads
		var candidate_cells_row = []
		for j in range(GRID_SIZE):
			if j != col and puzzle[row][j] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, row, j)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_row.append(other_possible_numbers)
		if check_for_hidden_quad(possible_numbers, candidate_cells_row):
			return true

		# Check the column for hidden quads
		var candidate_cells_col = []
		for i in range(GRID_SIZE):
			if i != row and puzzle[i][col] == 0:
				var other_possible_numbers = get_possible_numbers(puzzle, i, col)
				if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
					candidate_cells_col.append(other_possible_numbers)
		if check_for_hidden_quad(possible_numbers, candidate_cells_col):
			return true

		# Check the block for hidden quads
		var block_row_start = int(row / SUBGRID_SIZE) * SUBGRID_SIZE
		var block_col_start = int(col / SUBGRID_SIZE) * SUBGRID_SIZE
		var candidate_cells_block = []
		for i in range(SUBGRID_SIZE):
			for j in range(SUBGRID_SIZE):
				var r = block_row_start + i
				var c = block_col_start + j
				if (r != row or c != col) and puzzle[r][c] == 0:
					var other_possible_numbers = get_possible_numbers(puzzle, r, c)
					if array_intersect(possible_numbers, other_possible_numbers).size() > 0:
						candidate_cells_block.append(other_possible_numbers)
		if check_for_hidden_quad(possible_numbers, candidate_cells_block):
			return true

	return false

func apply_pointing_pairs(puzzle, row, col):
	var block_row_start = int(row / SUBGRID_SIZE) * SUBGRID_SIZE
	var block_col_start = int(col / SUBGRID_SIZE) * SUBGRID_SIZE
	var progress_made = false

	for num in range(1, 10):  # For each number from 1 to 9
		var cells_with_num = []

		# Check the block for cells with 'num' as a possible number
		for i in range(SUBGRID_SIZE):
			for j in range(SUBGRID_SIZE):
				var r = block_row_start + i
				var c = block_col_start + j
				if num in possible_numbers_grid[r][c]:
					cells_with_num.append(Vector2(r, c))

		# If there are exactly 2 cells with 'num' as a possible number
		if cells_with_num.size() == 2:
			var cell1 = cells_with_num[0]
			var cell2 = cells_with_num[1]

			# If the two cells are in the same row
			if cell1.x == cell2.x:
				for j in range(GRID_SIZE):
					if j < block_col_start or j >= block_col_start + SUBGRID_SIZE:  # Outside the block
						if num in possible_numbers_grid[int(cell1.x)][j]:
							possible_numbers_grid[int(cell1.x)][j].erase(num)
							progress_made = true

			# If the two cells are in the same column
			elif cell1.y == cell2.y:
				for i in range(GRID_SIZE):
					if i < block_row_start or i >= block_row_start + SUBGRID_SIZE:  # Outside the block
						if num in possible_numbers_grid[i][int(cell1.y)]:
							possible_numbers_grid[i][int(cell1.y)].erase(num)
							progress_made = true

	return progress_made

# Helper function for full house
func find_missing_number(nums):
	for i in range(1, GRID_SIZE + 1):
		if not nums.has(i):
			return i
	return -1

# Helper function for naked singles
func get_possible_numbers(puzzle, row_index, col_index):
	var possible = [1, 2, 3, 4, 5, 6, 7, 8, 9]  # Assuming a 9x9 grid

	# Remove numbers from the row
	for j in range(GRID_SIZE):
		if puzzle[row_index][j] in possible:
			possible.erase(puzzle[row_index][j])

	# Remove numbers from the column
	for i in range(GRID_SIZE):
		if puzzle[i][col_index] in possible:
			possible.erase(puzzle[i][col_index])

	# Remove numbers from the block
	var block_row_start = (row_index / SUBGRID_SIZE) * SUBGRID_SIZE
	var block_col_start = (col_index / SUBGRID_SIZE) * SUBGRID_SIZE
	for i in range(SUBGRID_SIZE):
		for j in range(SUBGRID_SIZE):
			var row = block_row_start + i
			var col = block_col_start + j
			if puzzle[row][col] in possible:
				possible.erase(puzzle[row][col])

	return possible

# Helper function for hidden single
func is_hidden_single(puzzle, row, col, num):
	var GRID_SIZE = puzzle.size()
	# Check row
	var row_count = 0
	for j in range(GRID_SIZE):
		if puzzle[row][j] == 0 and num in get_possible_numbers(puzzle, row, j):
			row_count += 1
	if row_count == 1:
		return true

	# Check column
	var col_count = 0
	for i in range(GRID_SIZE):
		if puzzle[i][col] == 0 and num in get_possible_numbers(puzzle, i, col):
			col_count += 1
	if col_count == 1:
		return true

	# Check block
	var SUBGRID_SIZE = int(sqrt(GRID_SIZE))
	var block_row_start = (row / SUBGRID_SIZE) * SUBGRID_SIZE
	var block_col_start = (col / SUBGRID_SIZE) * SUBGRID_SIZE
	var block_count = 0
	for i in range(SUBGRID_SIZE):
		for j in range(SUBGRID_SIZE):
			var r = block_row_start + i
			var c = block_col_start + j
			if puzzle[r][c] == 0 and num in get_possible_numbers(puzzle, r, c):
				block_count += 1
	if block_count == 1:
		return true

	return false

# Helper function for naked triples
func union(arrays):
	var result = []
	for array in arrays:
		for item in array:
			if not result.has(item):
				result.append(item)
	return result

# Helper function to check for hidden triples
func check_for_hidden_triple(possible_numbers, candidate_cells):
	if candidate_cells.size() < 3:
		return false

	for i in range(candidate_cells.size() - 2):
		for j in range(i + 1, candidate_cells.size() - 1):
			for k in range(j + 1, candidate_cells.size()):
				var combined = possible_numbers + candidate_cells[i] + candidate_cells[j] + candidate_cells[k]
				var unique_combined = array_to_unique_array(combined)
				if unique_combined.size() == 3:
					return true

	return false

# Helper function to convert an array to a unique array (similar to converting to a set)
func array_to_unique_array(arr):
	var dict_as_set = {}
	for item in arr:
		dict_as_set[item] = true
	return dict_as_set.keys()

# Helper function to get the intersection of two arrays
func array_intersect(arr1, arr2):
	var result = []
	for item in arr1:
		if arr2.has(item):
			result.append(item)
	return result

# Helper function to check for naked quads
func check_for_naked_quad(possible_numbers, candidate_cells):
	if candidate_cells.size() < 4:
		return false

	for i in range(candidate_cells.size() - 3):
		for j in range(i + 1, candidate_cells.size() - 2):
			for k in range(j + 1, candidate_cells.size() - 1):
				for l in range(k + 1, candidate_cells.size()):
					var combined = possible_numbers + candidate_cells[i] + candidate_cells[j] + candidate_cells[k] + candidate_cells[l]
					var unique_combined = array_to_unique_array(combined)
					if unique_combined.size() == 4:
						return true

	return false

# Helper function to check for hidden quads
func check_for_hidden_quad(possible_numbers, candidate_cells):
	if candidate_cells.size() < 4:
		return false

	for i in range(candidate_cells.size() - 3):
		for j in range(i + 1, candidate_cells.size() - 2):
			for k in range(j + 1, candidate_cells.size() - 1):
				for l in range(k + 1, candidate_cells.size()):
					var combined = possible_numbers + candidate_cells[i] + candidate_cells[j] + candidate_cells[k] + candidate_cells[l]
					var unique_combined = array_to_unique_array(combined)
					if unique_combined.size() == 4:
						return true

	return false

# List of techniques for each difficulty level
var difficulty_techniques = {
	"Easy": ["use_full_house", "use_naked_singles", "use_hidden_singles"],
	"Medium": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples", "use_naked_quads", "use_hidden_quads"],
	"Advanced": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"],
	# ... Add techniques for other difficulty levels
}

#Needed
var use_full_house = false
var use_naked_singles = false
#Basic
var use_hidden_singles = false
#Medium
var use_naked_pairs = false
var use_hidden_pairs = false
var use_naked_triples = false
var use_hidden_triples = false
var use_naked_quads = false
var use_hidden_quads = false
var use_pointing_pairs = false
var use_pointing_triples = false
var use_box_line_reduction = false
var use_locked_candidates = false
var use_x_wing = false
#Advanced
var use_swordfish = false
var use_jellyfish = false
var use_simple_coloring = false
var use_xyz_wing = false
var use_w_wing = false
var use_skyscraper = false
var use_two_string_kite = false
var use_empty_rectangle = false
var use_unique_rectangles = false
var use_finned_x_wing = false
var use_finned_swordfish = false
var use_finned_jellyfish = false
#Expert
var use_als_xz = false
var use_als_xy_wing = false
var use_death_blossom = false
var use_bug = false
var use_forcing_chains = false
var use_forcing_nets = false
var use_y_wing_style = false
var use_remote_pairs = false
var use_grouped_x_cycles = false
var use_3d_medusa = false
