#Global.gd
extends Node

var config = ConfigFile.new()
var highlight_identical_digits = false
var filled_sudoku = []
var puzzle_generated = false
var grid_lines_color = Color(0, 0,0)
var player_digit_color = Color(1, 0, 0)
var game_placed_digit_color = Color(0, 0, 0)
var selected_cell_color = Color(0.5, 0.5, 1, 1)
var identical_digits_color = Color(0.5, 0.5, 1, 0.5)
var game_background_texture = preload("res://DefaultSprites/Backgound.png")
var PuzzleGenerator = preload("res://Scenes/PuzzleGenerator.gd").new()
#var SudokuSolver = preload("res://Scenes/SudokuSolver.gd").new()
var CellScene = preload("res://Scenes/Cell.tscn")
var puzzle = []
var selected_cell = Vector2(-1, -1)
var selected_cells = []

var hint = false
var penciled_digits = []
var current_penciled_digits = []

func _ready():

	var hint = false
	load_selected_cell_color()
	load_player_placed_digit_color()
	load_grid_color()
	load_game_placed_digit_color()


#func send_grid(grid):
#	# Send the grid to PuzzleGenerator
#	PuzzleGenerator.receive_completed_grid(grid)

func fetch_grid(received_puzzle):
	puzzle = received_puzzle.duplicate()  # Store the received puzzle in the puzzle variable
	print(puzzle)

func toggle_highlight(value):
	highlight_identical_digits = value
	print("Highlight identical digits:", highlight_identical_digits) # Debugging print statement

func save_selected_cell_color(color):
	selected_cell_color = color
	config.load("user://settings.cfg")
	config.set_value("highlight", "color", color.to_html())
	config.save("user://settings.cfg")

func save_player_placed_digit_color(color):
	player_digit_color = color
	config.load("user://settings.cfg")
	config.set_value("player_digit", "color", color.to_html())
	config.save("user://settings.cfg")

func save_game_placed_digit_color(color):
	game_placed_digit_color = color
	config.load("user://settings.cfg")
	config.set_value("game_placed_digit", "color", color.to_html())
	config.save("user://settings.cfg")

func save_grid_color(color):
	grid_lines_color = color
	config.load("user://settings.cfg")
	config.set_value("grid_color", "color", color.to_html())
	config.save("user://settings.cfg")

func load_grid_color():
	config.load("user://settings.cfg")
	if config.has_section_key("grid_color", "color"):
		var grid_color_html = config.get_value("grid_color", "color")
		grid_lines_color = Color(grid_color_html)

func load_player_placed_digit_color():
	config.load("user://settings.cfg")
	if config.has_section_key("player_digit", "color"):
		var player_digit_color_html = config.get_value("player_digit", "color")
		player_digit_color = Color(player_digit_color_html)

func load_game_placed_digit_color():
	config.load("user://settings.cfg")
	if config.has_section_key("game_placed_digit", "color"):
		var game_digit_color_html = config.get_value("game_placed_digit", "color")
		game_placed_digit_color = Color(game_digit_color_html)

func load_selected_cell_color():
	config.load("user://settings.cfg")
	if config.has_section_key("highlight", "color"):
		var selected_cell_color_html = config.get_value("highlight", "color")
		selected_cell_color = Color(selected_cell_color_html)
