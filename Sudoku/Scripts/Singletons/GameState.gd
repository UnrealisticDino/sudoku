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
var grid_container

func fetch_grid(received_puzzle):
	puzzle = received_puzzle.duplicate()

func set_grid_container(container):
	grid_container = container
	print("GridContainer reference: ", grid_container)
