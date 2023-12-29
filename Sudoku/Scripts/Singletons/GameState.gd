#GameState
extends Node

var penciled_digits = []
var player_placed_digits = []
var puzzle = []
var save_button_name = ""
var selected_cells = []
var transition_source = ""
var number_source = []
#var current_penciled_digits = []

func fetch_grid(received_puzzle):
	puzzle = received_puzzle.duplicate()
