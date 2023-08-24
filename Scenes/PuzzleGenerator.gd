#PuzzleGenerator
extends Node

var difficulty = "Easy"  # Default difficulty

# Function to receive the filled Sudoku from Global.gd
func receive_completed_grid(grid):
	# Update techniques based on difficulty
	update_techniques_based_on_difficulty(Global.difficulty)
	
	# Generate the puzzle based on the enabled techniques
	var generated_puzzle = generate_puzzle(grid)
	
	# Send the generated puzzle to Global.gd using the new function
	Global.send_and_receive_grid(generated_puzzle)

# This function updates the techniques based on the provided difficulty.
func update_techniques_based_on_difficulty(difficulty):
	if difficulty == "Easy":
		use_full_house = true
		use_naked_singles = true
		use_hidden_singles = true
	# ... [handle other difficulties if needed]

# This function generates a puzzle based on the enabled techniques.
func generate_puzzle(filled_sudoku):
	var puzzle = filled_sudoku.duplicate()

	# Flatten the puzzle to a list of cell coordinates
	var cells_to_try_removing = _get_all_cells_in_random_order()
	var digit_removed = true  # Initialize variable to keep track of whether a digit was removed in the last iteration

	while digit_removed:  # Continue until no more digits can be removed
		digit_removed = false  # Reset the flag at the start of each loop
		for cell in cells_to_try_removing:
			var original_value = puzzle[cell.x][cell.y]
			if original_value == 0:  # Skip if the cell is already empty
				continue

			puzzle[cell.x][cell.y] = 0  # Temporarily remove the number

			# Check if the puzzle can still be solved using enabled techniques
			if not _is_solvable_with_enabled_techniques(puzzle, cell):
				puzzle[cell.x][cell.y] = original_value  # If not, restore the number
			else:
				digit_removed = true  # If yes, update the flag
				puzzle = puzzle
				print(puzzle)
		# Re-shuffle the cells for the next iteration to try removing digits in a different order
		cells_to_try_removing.shuffle()

	return puzzle

func _get_all_cells_in_random_order():
	var cells = []
	for i in range(9):
		for j in range(9):
			cells.append(Vector2(i, j))
	cells.shuffle()
	return cells

func _is_solvable_with_enabled_techniques(puzzle, cell):
	var temp_puzzle = puzzle.duplicate()
	# Check if the cell is already filled
	if temp_puzzle[cell.x][cell.y] != 0:
		return false

	# Apply Naked Singles Technique on the specific cell
	if use_naked_singles and _apply_naked_single_on_cell(temp_puzzle, cell):
		return temp_puzzle

	# Apply Hidden Singles Technique on the specific cell
#	if use_hidden_singles and _apply_hidden_single_on_cell(temp_puzzle, cell):
#		return temp_puzzle

	# ... Add other techniques here for the specific cell

	# If no technique could fill the cell, return false
	return false

func _apply_naked_single_on_cell(puzzle, cell):
	var possibilities = _get_possibilities(cell.x, cell.y, puzzle)
	if len(possibilities) == 1:
		puzzle[cell.x][cell.y] = possibilities[0]
		return true
	return false

func _apply_hidden_singles(puzzle):
	# For each row, column, and box, if a number appears as a possibility in only one cell, fill it in.
	var made_changes = false
	# TODO: Implement the logic for hidden singles
	return made_changes

func _apply_naked_pairs(puzzle):
	# If two cells in a row, column, or box have the same two possibilities and only those two, remove those numbers as possibilities from other cells in that row, column, or box.
	var made_changes = false
	# TODO: Implement the logic for naked pairs
	return made_changes

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
	"Intermediate": ["use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples"],
	"Advanced": ["use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"],
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
