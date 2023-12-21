# MediumButton.gd
extends Button

var button_count = 0
var ButtonManager = preload("res://Sudoku/Scripts/SaveFiles/ButtonManager.gd").new()
var difficulty_setting = "Medium"

func _on_Medium_button_up():
	print("Difficulty setting: " + difficulty_setting)

	# For the Medium button, the difficulty level is set to 1
	var difficulty_level = 1

	# Create an instance of the Sudoku class
	var sudoku_script = load("res://Sudoku/TMP/Sudokutmpgenerator.gd").new()

	# Generate a sudoku puzzle with the Medium difficulty level
	sudoku_script.gen(difficulty_level)

	# Get the generated grid from the Sudoku instance
	var generated_puzzle = sudoku_script.get_grid()
	Global.puzzle = generated_puzzle
	
	# Deferred setup for adding load button
	call_deferred("_deferred_setup")
	
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")

func _deferred_setup():
	var grid_container_path = "../../VScrollBar/VBoxContainer/GridContainer"
	var grid_container = get_node_or_null(grid_container_path)

	if grid_container:
		ButtonManager.add_load_button(grid_container, difficulty_setting)
	else:
		print("Error: GridContainer not found at path: ", grid_container_path)
