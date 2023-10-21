# SudokuSolver
extends Node

var difficulty = "Easy"
var config = ConfigFile.new()
var move_details = []  # Data structure to keep track of the moves made
var hint_cell
var hint_number

func load_settings():
	var err = config.load("user://settings.cfg")
	if err == OK:
		difficulty = config.get_value("difficulty", "selected", "Easy")

func solve(puzzle, filled_sudoku, source):
	load_settings()
	move_details.clear()
	
	# Allowed techniques depending on the difficulty
	var allowed_techniques = []
	match difficulty:
		"Easy":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles"]
		"Medium":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples", "use_naked_quads", "use_hidden_quads"]
		"Hard":
			allowed_techniques = ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"]
	
	# Solve the puzzle using the allowed techniques
	var solved_puzzle = solve_with_techniques(puzzle, allowed_techniques, source)

	if solved_puzzle == filled_sudoku:
		print_moves_made()
		return true
	else:
		return false

func solve_with_techniques(puzzle, techniques, source):
	var last_filled_cell = {}
	var is_solved = false
	while not is_solved:
		var made_move = false
		var move_result = {}
		for technique in techniques:
			match technique:
				#Easy
				"use_full_house":
					move_result = use_full_house(puzzle)
				"use_naked_singles":
					move_result = use_naked_singles(puzzle)
				"use_hidden_singles":
					move_result = use_hidden_singles(puzzle)
				#Medium
#				"use_naked_pairs":
#					move_result = use_naked_pairs(puzzle)
				# ... (other techniques)
			made_move = move_result.made_move or made_move
			
			# If the source is "player_input", exit early if a move was made
			if source == "PlayerInput" and made_move:
				Global.hint = true
				var DrawGrid = get_tree().get_nodes_in_group("DrawGridGroup")[0]
				if DrawGrid:
					print(move_result.cell)
					DrawGrid.input_number(move_result.cell, move_result.number)
					return
				else:
					print("DrawGrid is not available.")
				return

		if not made_move:
			break
		is_solved = check_if_solved(puzzle)
	return puzzle

# Prints the moves made and the eliminated values to a file
func print_moves_made():
	var file = File.new()
	file.open("res://Moves_Made/moves.txt", File.WRITE)
	
	file.store_string("Moves made:\n")
	for move in move_details:
		file.store_string("Row: %d, Col: %d, Value: %d, Technique: %s\n" % [move["row"], move["col"], move["value"], move["technique"]])
		
		if move.has("eliminated_values"):
			file.store_string("Eliminated values: %s\n" % [str(move["eliminated_values"])])
	
	file.close()

# Checks if the puzzle is solved
func check_if_solved(puzzle):
	for row in puzzle:
		for cell in row:
			if cell == 0:
				return false
	return true

# Full House technique
func use_full_house(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				var eliminated_values = {}
				
				# Check row and column
				for x in range(9):
					if puzzle[i][x] in possible_values:
						eliminated_values[puzzle[i][x]] = "Exists in row"
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						eliminated_values[puzzle[x][j]] = "Exists in column"
						possible_values.erase(puzzle[x][j])

				# Check 3x3 block
				var block_row = i / 3 * 3
				var block_col = j / 3 * 3
				for x in range(block_row, block_row + 3):
					for y in range(block_col, block_col + 3):
						if puzzle[x][y] in possible_values:
							eliminated_values[puzzle[x][y]] = "Exists in block"
							possible_values.erase(puzzle[x][y])

				# If only one possible value, it's a full house
				if possible_values.size() == 1:
					puzzle[i][j] = possible_values[0]
					move_details.append({"row": i, "col": j, "value": possible_values[0], "technique": "Full House", "eliminated_values": eliminated_values})
					return {"made_move": true, "cell": Vector2(i, j), "number": possible_values[0]}
	return {"made_move": false}

# Naked Single technique
func use_naked_singles(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				var eliminated_values = {}
				
				for x in range(9):
					if puzzle[i][x] in possible_values:
						eliminated_values[puzzle[i][x]] = "Exists in row"
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						eliminated_values[puzzle[x][j]] = "Exists in column"
						possible_values.erase(puzzle[x][j])
				
				if possible_values.size() == 1:
					puzzle[i][j] = possible_values[0]
					move_details.append({"row": i, "col": j, "value": possible_values[0], "technique": "Naked Single", "eliminated_values": eliminated_values})
					return {"made_move": true, "cell": Vector2(i, j), "number": possible_values[0]}
	return {"made_move": false}

# Hidden Single technique
func use_hidden_singles(puzzle):
	for i in range(9):
		for j in range(9):
			if puzzle[i][j] == 0:
				var possible_values = [1, 2, 3, 4, 5, 6, 7, 8, 9]
				var eliminated_values = {}  # Added this dictionary to track eliminated values
				
				# Check row and column
				for x in range(9):
					if puzzle[i][x] in possible_values:
						# Removing values that are already in the row
						eliminated_values[puzzle[i][x]] = "Exists in row"
						possible_values.erase(puzzle[i][x])
					if puzzle[x][j] in possible_values:
						# Removing values that are already in the column
						eliminated_values[puzzle[x][j]] = "Exists in column"
						possible_values.erase(puzzle[x][j])
				
				# Check block
				var block_row = i / 3 * 3
				var block_col = j / 3 * 3
				for x in range(block_row, block_row + 3):
					for y in range(block_col, block_col + 3):
						if puzzle[x][y] in possible_values:
							eliminated_values[puzzle[x][y]] = "Exists in block"
							possible_values.erase(puzzle[x][y])
				
				# If only one possible value remains, it's a Hidden Single
				if possible_values.size() == 1:
					puzzle[i][j] = possible_values[0]
					move_details.append({
						"row": i,
						"col": j,
						"value": possible_values[0],
						"technique": "Hidden Single",
						"eliminated_values": eliminated_values  # Record the eliminated values
					})
					return {"made_move": true, "cell": Vector2(i, j), "number": possible_values[0]}
	return {"made_move": false}

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
