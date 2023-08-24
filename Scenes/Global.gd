#Global.gd
extends Node

var config = ConfigFile.new()
var highlight_identical_digits = false
var filled_sudoku = []
var puzzle_generated = false
var selected_cell_color = Color(0.5, 0.5, 1, 1)  # Default blueish color for the selected cell
var identical_digits_color = Color(0.5, 0.5, 1, 0.5)  # Default derived color with added transparency
var game_background_texture = preload("res://DefaultSprites/Backgound.png")
var PuzzleGenerator = preload("res://Scenes/PuzzleGenerator.gd").new()
var puzzle = []
var difficulty = "Easy"

const GENERATED_COLOR = Color(0.5, 0.5, 0.5)  # Gray color for generated numbers
const PLAYER_COLOR = Color(1, 1, 1)  # White color for player numbers

func _ready():
	randomize()
	load_selected_cell_color()
	if not puzzle_generated:
		filled_sudoku = generate_full_grid()
		puzzle_generated = true
		print("Generated sudoku grid:")
		for row in filled_sudoku:
			print(row)
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		highlight_identical_digits = config.get_value("settings", "highlight_identical_digits", false) # Default to false if not found

func send_and_receive_grid(grid):
	# Send the grid to PuzzleGenerator
	PuzzleGenerator.receive_completed_grid(grid)
	
	# Receive the generated puzzle from PuzzleGenerator
	puzzle = PuzzleGenerator.temp_puzzle  # Assuming PuzzleGenerator stores the generated puzzle in a variable named temp_puzzle
	
	# Print the received puzzle
	for row in puzzle:
		print(row)

func load_selected_cell_color():
	config.load("user://settings.cfg")
	if config.has_section_key("highlight", "color"):
		var saved_color_html = config.get_value("highlight", "color")
		selected_cell_color = Color(saved_color_html)

func toggle_highlight(value):
	highlight_identical_digits = value
	print("Highlight identical digits:", highlight_identical_digits) # Debugging print statement

func generate_full_grid():
	var grid = []
	for row in range(9):
		var row_data = []
		for col in range(9):
			row_data.append(0)
		grid.append(row_data)
	# Fill the diagonal 3x3 subgrids
	for i in range(0, 9, 3):
		fill_subgrid(grid, i, i)
	# Fill the remaining cells
	solve_grid(grid)
	return grid

func fill_subgrid(grid, row, col):
	var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	numbers.shuffle()
	for i in range(3):
		for j in range(3):
			grid[row + i][col + j] = numbers.pop_front()

func solve_grid(grid):
	var empty_cell = find_empty_cell(grid)
	if empty_cell == null:
		return true # Puzzle is solved

	var row = empty_cell[0]
	var col = empty_cell[1]

	for num in range(1, 10):
		if is_safe_to_place_number(grid, row, col, num):
			grid[row][col] = num
			if solve_grid(grid):
				return true # Continue if the solution is found
			grid[row][col] = 0 # Backtrack if no solution is found

	return false # Trigger backtracking

func find_empty_cell(grid):
	for row in range(9):
		for col in range(9):
			if grid[row][col] == 0:
				return [row, col]
	return null

func is_safe_to_place_number(grid, row, col, num):
	# Check row, column, and 3x3 subgrid
	for x in range(9):
		if grid[row][x] == num or grid[x][col] == num or grid[row - row % 3 + int(x / 3)][col - col % 3 + x % 3] == num:
			return false
	return true

func save_selected_cell_color(color):
	selected_cell_color = color
	config.load("user://settings.cfg")
	config.set_value("highlight", "color", color.to_html())
	config.save("user://settings.cfg")
