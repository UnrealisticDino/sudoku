#SudokuSolver.gd
extends Node

var difficulty = "Easy"
var config = ConfigFile.new()
var move_details = []  # Data structure to keep track of the moves made
var hint_cell
var hint_number
# Import technique scripts
var NakedSingles = preload("res://Scripts/NakedSingles.gd")

func load_settings():
	var err = config.load("user://settings.cfg")
	if err == OK:
		difficulty = config.get_value("difficulty", "selected", "Easy")

# Main solving function
func solve_sudoku(grid: Array, techniques: Array) -> Array:
	var current_grid = grid.duplicate()
	var made_changes = false

	for technique in techniques:
		match technique:
			"Naked Singles":
				var result = NakedSingles.solve_naked_singles(current_grid)
				current_grid = result[0]  # Updated grid
				if result[1]:
					made_changes = true
			# Add cases for other techniques

	# Return both the updated grid and whether any changes were made
	return [current_grid, made_changes]
