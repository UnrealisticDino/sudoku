#GameState
extends Node

var current_pointer = -1
var history_stack = []
var number_source = []
var penciled_digits = []
var player_placed_digits = []
var puzzle = []
var save_button_name = ""
var selected_cell = Vector2(-1, -1)
var selected_cells = []
var transition_source = ""
var test = 0
#var grid_container
var thread = Thread.new()
var sudoku_generator_script = load("res://Sudoku/Scripts/SudokuGenerator/SudokuGenerator.gd")

func _ready():
	thread.start(self, "run_sudoku_generator_in_background")

func run_sudoku_generator_in_background():
	var sudoku_generator_instance = sudoku_generator_script.new()
	sudoku_generator_instance._ready()

func _exit_tree():
	if thread.is_active():
		thread.wait_to_finish()
