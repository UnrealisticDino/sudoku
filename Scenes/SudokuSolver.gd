#SudokuSolver
extends Node
var difficulty = "Easy"

var config = ConfigFile.new()

func load_settings():
	# Load settings from the config file
	var err = config.load("user://settings.cfg")
	if err == OK:
		difficulty = config.get_value("difficulty", "selected", "Easy")  # Default to "Easy" if not found

# Implement human-viable techniques for solving Sudoku
func solve(puzzle, filled_sudoku):
	load_settings()
	
	var allowed_techniques = []

	match difficulty:
		"Easy":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles"]
		"Medium":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples", "use_naked_quads", "use_hidden_quads"]
		"Hard":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"]
	# Solve the puzzle using only the allowed techniques
	var solved_puzzle = solve_with_techniques(puzzle, allowed_techniques)

	# Check if the solved puzzle matches the original filled grid
	if solved_puzzle == filled_sudoku:
		return true
	else:
		return false

func solve_with_techniques(puzzle, techniques):
	var is_solved = false

	while not is_solved:
		var made_move = false
		for technique in techniques:
			match technique:
				"use_full_house":
					made_move = use_full_house(puzzle) or made_move
				"use_naked_singles":
					made_move = use_naked_singles(puzzle) or made_move
				"use_hidden_singles":
					made_move = use_hidden_singles(puzzle) or made_move
				
				# ... (other techniques)

		if not made_move:
			break  # No more moves can be made, exit the loop
		is_solved = check_if_solved(puzzle)
	return puzzle

func check_if_solved(puzzle):
	for row in puzzle:
		for cell in row:
			if cell == 0:
				return false
	return true

func use_full_house(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				for x in range(9):
					if puzzle[i][x] in possible_values:
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						possible_values.erase(puzzle[x][j])
				var box_row = i - i % 3
				var box_col = j - j % 3
				for x in range(box_row, box_row + 3):
					for y in range(box_col, box_col + 3):
						if puzzle[x][y] in possible_values:
							possible_values.erase(puzzle[x][y])
				if possible_values.size() == 1:
					puzzle[i][j] = possible_values[0]
					return true
	return false

func use_naked_singles(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				for x in range(9):
					if puzzle[i][x] in possible_values:
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						possible_values.erase(puzzle[x][j])
				var box_row = i - i % 3
				var box_col = j - j % 3
				for x in range(box_row, box_row + 3):
					for y in range(box_col, box_col + 3):
						if puzzle[x][y] in possible_values:
							possible_values.erase(puzzle[x][y])
				if possible_values.size() == 1:
					puzzle[i][j] = possible_values[0]
					return true
	return false

func use_hidden_singles(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				for x in range(9):
					if puzzle[i][x] in possible_values:
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						possible_values.erase(puzzle[x][j])
				var box_row = i - i % 3
				var box_col = j - j % 3
				for x in range(box_row, box_row + 3):
					for y in range(box_col, box_col + 3):
						if puzzle[x][y] in possible_values:
							possible_values.erase(puzzle[x][y])
				for value in possible_values:
					var count_row = 0
					var count_col = 0
					var count_box = 0
					for x in range(9):
						if puzzle[i][x] == value:
							count_row += 1
						if puzzle[x][j] == value:
							count_col += 1
					for x in range(box_row, box_row + 3):
						for y in range(box_col, box_col + 3):
							if puzzle[x][y] == value:
								count_box += 1
					if count_row == 0 and count_col == 0 and count_box == 0:
						puzzle[i][j] = value
						return true
	return false

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
#Hard Maybe
var use_naked_quads = false
var use_hidden_quads = false
#Stopping point
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
