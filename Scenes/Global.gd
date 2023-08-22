#Global.gd
extends Node

var config = ConfigFile.new()
var highlight_identical_digits = false
var filled_sudoku = []
var puzzle_generated = false
var selected_cell_color = Color(0.5, 0.5, 1, 1)  # Default blueish color for the selected cell
var identical_digits_color = Color(0.5, 0.5, 1, 0.5)  # Default derived color with added transparency
var game_background_texture = preload("res://DefaultSprites/Backgound.png")
var puzzle = []
var difficulty = "Easy"

# Techniques for puzzle generation
var techniques = {
	"use_full_house": true,
	"use_naked_singles": true,
	"use_hidden_singles": true,
	"use_naked_pairs": true,
	"use_hidden_pairs": true,
	"use_naked_triples": true,
	"use_hidden_triples": true,
	"use_naked_quads": true,
	"use_hidden_quads": true,
	"use_pointing_pairs": true,
	"use_pointing_triples": true,
	"use_box_line_reduction": true,
	"use_locked_candidates": true,
	"use_x_wing": true,
	"use_swordfish": true,
	"use_jellyfish": true,
	"use_simple_coloring": true,
	"use_xyz_wing": true,
	"use_w_wing": true,
	"use_skyscraper": true,
	"use_two_string_kite": true,
	"use_empty_rectangle": true,
	"use_unique_rectangles": true,
	"use_finned_x_wing": true,
	"use_finned_swordfish": true,
	"use_finned_jellyfish": true,
	"use_als_xz": true,
	"use_als_xy_wing": true,
	"use_death_blossom": true,
	"use_bug": true,
	"use_forcing_chains": true,
	"use_forcing_nets": true,
	"use_y_wing_style": true,
	"use_remote_pairs": true,
	"use_grouped_x_cycles": true,
	"use_3d_medusa": true
}

func _ready():
	randomize()
	load_selected_cell_color()
	if not puzzle_generated:
		request_puzzle_generation()
	var err = config.load("user://settings.cfg")
	if err == OK:
		highlight_identical_digits = config.get_value("settings", "highlight_identical_digits", false) # Default to false if not found

func load_selected_cell_color():
	config.load("user://settings.cfg")
	if config.has_section_key("highlight", "color"):
		var saved_color_html = config.get_value("highlight", "color")
		selected_cell_color = Color(saved_color_html)

func toggle_highlight(value):
	highlight_identical_digits = value
	print("Highlight identical digits:", highlight_identical_digits) # Debugging print statement

func request_puzzle_generation():
	puzzle = $PuzzleGenerator.generate_puzzle(techniques, difficulty)
	puzzle_generated = true

func save_selected_cell_color(color):
	selected_cell_color = color
	config.load("user://settings.cfg")
	config.set_value("highlight", "color", color.to_html())
	config.save("user://settings.cfg")
