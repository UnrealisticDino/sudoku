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
#	print(difficulty)
#	print(puzzle)
	match difficulty:
		"Easy":
			allowed_techniques = ["NakedSingles", "HiddenSingles"]
		"Medium":
			allowed_techniques = ["NakedSingles", "HiddenSingles", "PointingPairs"]
		"Hard":
			allowed_techniques = ["NakedSingles", "HiddenSingles", "PointingPairs", "BoxLineReduction"]
	print(allowed_techniques)
	# Solve the puzzle using only the allowed techniques
	var solved_puzzle = solve_with_techniques(puzzle, allowed_techniques)
	
	# Check if the solved puzzle matches the original filled grid
	if solved_puzzle == filled_sudoku:
		return true
	else:
		return false

func solve_with_techniques(puzzle, techniques):
	# Implement the solving logic here using only the allowed techniques
	return puzzle


# List of techniques for each difficulty level
var difficulty_techniques = {
	"Easy": ["use_full_house", "use_naked_singles", "use_hidden_singles"],
	"Medium": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_pairs", "use_hidden_pairs", "use_naked_triples", "use_hidden_triples", "use_naked_quads", "use_hidden_quads"],
	"Advanced": ["use_full_house", "use_naked_singles", "use_hidden_singles", "use_naked_quads", "use_hidden_quads", "use_pointing_pairs", "use_pointing_triples"],
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
