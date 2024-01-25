#EasyButton.gd
extends Button

var ButtonManager = preload("res://Sudoku/Scripts/SaveFiles/ButtonManager.gd").new()
var difficulty_setting = "Easy"
var file_path = "user://SudokuPuzzles/Easy.json"

func _on_Easy_button_up():
	# Read the JSON file
	var file = File.new()
	if file.open(file_path, File.READ) == OK:
		var json_text = file.get_as_text()
		file.close()

		# Parse the JSON text
		var puzzles = parse_json(json_text)
		if puzzles.empty():
			print("No puzzles found in the JSON file.")
			return

		# Select a random puzzle and convert integers to floats
		var random_index = randi() % puzzles.size()
		var selected_puzzle = puzzles[random_index]

		# Convert each element of the retrieved puzzle to integer
		var converted_puzzle = []
		for row in selected_puzzle:
			var converted_row = []
			for cell in row:
				converted_row.append(int(cell))
			converted_puzzle.append(converted_row)
		GameState.puzzle = converted_puzzle

		# Remove the selected puzzle from the puzzles array
		puzzles.remove(random_index)

		# Convert the updated puzzles array to JSON text
		var updated_json_text = to_json(puzzles)

		# Write the updated JSON text back to the file
		if file.open(file_path, File.WRITE) == OK:
			file.store_string(updated_json_text)
			file.close()
		else:
			print("Failed to open file for writing: " + file_path)

		# Deferred setup for additional logic
		call_deferred("_deferred_setup", converted_puzzle)
	else:
		print("Failed to open file: " + file_path)

func _deferred_setup(selected_puzzle):
	var grid_container_path = "../../VBoxContainer/GridContainer"
	var grid_container = get_node_or_null(grid_container_path)

	if grid_container:
		var button_name = ButtonManager.add_load_button(grid_container, difficulty_setting, selected_puzzle)

		# Set the button name in the global singleton
		GameState.save_button_name = button_name

		# Transition to the Sudoku scene
		get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
	else:
		print("Error: GridContainer not found at path: ", grid_container_path)
