# HardButton.gd
extends Button

var button_count = 0
var ButtonManager = preload("res://Sudoku/Scripts/SaveFiles/ButtonManager.gd").new()

func _on_Hard_button_up():
	# Set the difficulty to Hard
	var difficulty_setting = "Hard"
	print("Difficulty setting: " + difficulty_setting)

	# For the Hard button, the difficulty level is set to 2
	var difficulty_level = 2

	# Create an instance of the Sudoku class
	var sudoku_script = load("res://Sudoku/TMP/Sudokutmpgenerator.gd").new()

	# Generate a sudoku puzzle with the Hard difficulty level
	sudoku_script.gen(difficulty_level)

	# Get the generated grid from the Sudoku instance
	var generated_puzzle = sudoku_script.get_grid()
	Global.puzzle = generated_puzzle
	
	# Deferred setup for adding load button
	call_deferred("_deferred_setup")
	
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")

func _deferred_setup():
	var hbox_container_path = "../../VScrollBar/VBoxContainer/GridContainer"  # Adjusted path
	var hbox_container = get_node_or_null(hbox_container_path)

	if hbox_container:
		ButtonManager.add_load_button(hbox_container, "Hard")
	else:
		print("Error: HBoxContainer not found at path: ", hbox_container_path)
