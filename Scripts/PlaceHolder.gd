#PlaceHolder
extends Button

func _on_PlaceHolder_button_up():
	# Load the config file
	var config = ConfigFile.new()
	var config_path = "user://settings.cfg"
	var error = config.load(config_path)

	# Check for error in loading the config file
	if error != OK:
		print("Error loading config file: ", error)
		return

	# Read the difficulty setting from the config file
	# Ensure the section and key match what's used in the Settings script
	var difficulty_setting = config.get_value("difficulty", "selected", "Easy")

	# Print the difficulty setting for debugging
	print("Difficulty setting: " + difficulty_setting)

	# Translate the difficulty setting to numeric value
	var difficulty_level = 0  # Default to Easy
	if difficulty_setting == "Medium":
		difficulty_level = 1
	elif difficulty_setting == "Hard":
		difficulty_level = 2

	# Create an instance of the Sudoku class
	var sudoku_script = load("res://Sudoku/TMP/Sudokutmpgenerator.gd").new()

	# Generate a sudoku puzzle with the determined difficulty level
	sudoku_script.gen(difficulty_level)

	# Get the generated grid from the Sudoku instance
	var generated_puzzle = sudoku_script.get_grid()
	Global.puzzle = generated_puzzle
	print(Global.puzzle)
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
