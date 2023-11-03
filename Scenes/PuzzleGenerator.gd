# PuzzleGenerator.gd
extends Node

# Load the GDNativeLibrary resource
var gdnative_lib = preload("res://QQWingLibrary.gdnlib")

# Instance of the native script associated with your GDNative library
var qqwing_script = preload("res://QQWingWrapper.gdns")

var qqwing_instance = qqwing_script.new()

var game_board = Array()
var current_difficulty = "easy"  # Default value

var difficulty_mapping = {
	"Easy": "easy",
	"Medium": "medium",
	"Hard": "hard"
}

func _ready():
	load_settings()
	initialize_game_board()
	if qqwing_instance:
		qqwing_instance.initialize()

func initialize_game_board():
	for i in range(9):
		game_board.append([0] * 9)  # More concise way to initialize rows

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		var difficulty_from_settings = config.get_value("difficulty", "selected", "Easy")
		current_difficulty = difficulty_mapping.get(difficulty_from_settings, "easy")

func generate_sudoku():
	print("Current difficulty is:", current_difficulty)
	if qqwing_instance:
		var puzzle_string = qqwing_instance.generate_sudoku(current_difficulty)
		parse_puzzle_string(puzzle_string)
	else:
		print("QQWing instance not loaded or initialized properly.")

func parse_puzzle_string(puzzle_string):
	# Parse the generated Sudoku puzzle string into the game board
	if puzzle_string and puzzle_string.size() == 81:  # Ensure the puzzle string is valid
		var index = 0
		for i in range(9):
			for j in range(9):
				game_board[i][j] = int(puzzle_string[index])
				index += 1
	else:
		print("Error in generating Sudoku.")

func send_grid(grid):
	Global.fetch_grid(grid)

func _exit_tree():
	if qqwing_instance:
		qqwing_instance.shutdown()
