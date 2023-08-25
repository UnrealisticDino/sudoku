#PuzzleGenerator
extends Node
var difficulty = "Easy"
var GRID_SIZE = 9
var SUBGRID_SIZE = 3

# Function to receive the filled Sudoku from Global.gd
func receive_completed_grid(grid):
	print("does this wokr")
	var puzzle = generate_puzzle(grid, difficulty)
	# Send the generated puzzle to Global.gd using the new function
	Global.send_and_receive_grid(puzzle)

# This function generates a puzzle based on the difficulty's techniques.
func generate_puzzle(filled_sudoku, difficulty):
	var puzzle = filled_sudoku.duplicate()
	
	# Check if the puzzle is solvable with the given techniques for the difficulty
	if is_solvable_with_techniques(puzzle, difficulty):
		return puzzle
	

func is_solvable_with_techniques(puzzle, difficulty):
	# Set flags based on the selected difficulty
	if difficulty in difficulty_techniques:
		for technique in difficulty_techniques[difficulty]:
			match technique:
				#Easy
				"use_full_house":
					use_full_house = true
				"use_naked_singles":
					use_naked_singles = true
				"use_hidden_singles":
					use_hidden_singles = true
				#Intermediate
				"use_naked_pairs":
					use_naked_pairs = true
		
# Start a loop to iteratively remove digits and check solvability
	var successful_removal = true
	
	var tried_cells = []  # Initialize an empty list to keep track of tried cells
	while successful_removal:
		successful_removal = false  # Reset the flag

		var row = randi() % GRID_SIZE
		var col = randi() % GRID_SIZE
		if [row, col] in tried_cells:  # If the cell has already been tried, continue to the next iteration
			continue

		tried_cells.append([row, col])  # Add the current cell to the tried list


		if puzzle[row][col] != 0:  # If the cell is not already empty
			var backup_value = puzzle[row][col]
			puzzle[row][col] = 0  # Remove the number

			var solvable = true
			
			if use_full_house:
				solvable = solvable and apply_full_house(puzzle, row, col)
				if solvable == false:
					successful_removal = false

#			if use_naked_singles:
#				solvable = solvable and apply_naked_singles(puzzle)
#			if use_hidden_singles:
#				solvable = solvable and apply_hidden_singles(puzzle)

			if solvable:
				successful_removal = true  # Continue removing other numbers
			else:
				puzzle[row][col] = backup_value  # Restore the removed number if not solvable
	if not successful_removal:
		print("solved" )
		#receive_completed_grid(puzzle)
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

func apply_naked_singles(puzzle):

	return true
	
func apply_hidden_singles(puzzle):
	# Implement the technique and return true if progress is made, false otherwise.
	return true

#func find_missing_number_and_fill(puzzle, row_index, col_index):
#	row = puzzle[row_index]
#	if row.count(0) == 1:  # Only one empty cell in the row
#		missing_number = 45 - sum(row)  # Since sum of numbers from 1-9 is 45
#		row[col_index] = missing_number  # Fill in the missing number

func find_missing_number(nums):
	for i in range(1, GRID_SIZE + 1):
		if not nums.has(i):
			return i
	return -1

func _get_possibilities(x, y, puzzle):
	var possibilities = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	for i in range(9):
		if puzzle[x][i] in possibilities:
			possibilities.erase(puzzle[x][i])
		if puzzle[i][y] in possibilities:
			possibilities.erase(puzzle[i][y])
	var start_x = int(x / 3) * 3
	var start_y = int(y / 3) * 3
	for i in range(3):
		for j in range(3):
			if puzzle[start_x + i][start_y + j] in possibilities:
				possibilities.erase(puzzle[start_x + i][start_y + j])
	return possibilities

# List of techniques for each difficulty level
var difficulty_techniques = {
	"Easy": ["use_full_house", "use_naked_singles", "use_hidden_singles"],
	"Intermediate": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples"],
	"Advanced": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"],
	# ... Add techniques for other difficulty levels
}

#Basic
var use_full_house = false
var use_naked_singles = false
var use_hidden_singles = false
#Intermediate
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
