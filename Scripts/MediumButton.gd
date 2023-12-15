# MediumButton.gd
extends Button

var button_count = 0
var ButtonManager = preload("res://Sudoku/SaveFiles/ButtonManager.gd").new()

func _on_Medium_button_up():
	# Set the difficulty to Medium
	var difficulty_setting = "Medium"
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
	var hbox_container_path = "../../VScrollBar/VBoxContainer"  # Adjusted path
	var hbox_container = get_node_or_null(hbox_container_path)

	if hbox_container:
		ButtonManager.add_load_button(hbox_container, "Medium")
	else:
		print("Error: HBoxContainer not found at path: ", hbox_container_path)
