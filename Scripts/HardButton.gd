# HardButton.gd
extends Button

var ButtonManager = preload("res://Sudoku/Scripts/SaveFiles/ButtonManager.gd").new()
var difficulty_setting = "Hard"

func _on_Hard_button_up():
	print("Difficulty setting: " + difficulty_setting)

	# For the Hard button, the difficulty level is set to 2
	var difficulty_level = 2

	# Create an instance of the Sudoku class
	var sudoku_script = load("res://Sudoku/TMP/Sudokutmpgenerator.gd").new()

	# Generate a sudoku puzzle with the Easy difficulty level
	sudoku_script.gen(difficulty_level)

	# Get the generated grid from the Sudoku instance
	var generated_puzzle = sudoku_script.get_grid()
	GameState.puzzle = generated_puzzle
	
	# Deferred setup for adding load button
	call_deferred("_deferred_setup", generated_puzzle)

func _deferred_setup(generated_puzzle):
	var grid_container_path = "../../VBoxContainer/GridContainer"
	var grid_container = get_node_or_null(grid_container_path)
	
	if grid_container:
		var button_name = ButtonManager.add_load_button(grid_container, difficulty_setting, generated_puzzle)
		
		# Set the button name in the global singleton
		GameState.save_button_name = button_name

		# Transition to the Sudoku scene
		get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
	else:
		print("Error: GridContainer not found at path: ", grid_container_path)
