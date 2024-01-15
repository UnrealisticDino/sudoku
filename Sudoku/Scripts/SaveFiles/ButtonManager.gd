#ButtonManager
extends Node
var puzzle

# Function to add a load button
func add_load_button(grid_container, difficulty, puzzle):
	var current_datetime = OS.get_datetime_from_unix_time(OS.get_unix_time())
	var time_string = "%02d:%02d" % [current_datetime.hour, current_datetime.minute]
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/Old-Standard-TT/OldStandard-Regular.ttf")
	font.size = 50

	# Create and configure the load button
	var load_button = Button.new()
	load_button.text = "%s - %s" % [difficulty, time_string]
	load_button.rect_min_size = Vector2(200, 50)
	load_button.add_font_override("font", font)

	grid_container.add_child(load_button)

	# Create and add a delete button
	var delete_button = Button.new()
	delete_button.rect_min_size = Vector2(100, 50)

	# Save the state of the newly created button
	save_button_state(load_button.text, puzzle)

	return load_button.text

func save_button_state(button_text, puzzle):
	var button_state = {
		"puzzle": puzzle,
		"solved": false
	}

	var file = File.new()
	var save_path = "user://" + button_text + "_save.json"
	file.open(save_path, File.WRITE)
	var json_data = to_json(button_state)
	file.store_string(json_data)
	file.close()

func get_button_state(button_text):
	# File path for the specific button's state
	var file_path = "user://" + button_text + "_save.json"
	var file = File.new()

	# Check if the file for this button exists
	if file.file_exists(file_path):
		# Open the file in read mode
		var error = file.open(file_path, File.READ)
		if error != OK:
			print("Failed to open file: ", file.get_error())
			return null

		var json_data = file.get_as_text()
		file.close()  # Close the file after reading

		var button_data = parse_json(json_data)
		if button_data == null:
			print("Failed to parse JSON from file.")
			return null

		# Return the state if available
		if button_data.has("state"):
			return button_data["state"]
		else:
			print("No state data found for button: ", button_text)
	else:
		print("File not found for button: ", file_path)

	return null

func update_button_state_in_file(button_name: String, new_state) -> bool:
	var file = File.new()
	var file_path = "user://" + button_name + ".json"

	var data_to_store = ""

	if new_state is Array:
		# If new_state is an array, simply convert it to JSON.
		data_to_store = to_json(new_state)
	elif new_state is Dictionary:
		# If new_state is a dictionary, read existing data and merge it
		var existing_data = {}
		if file.file_exists(file_path) and file.open(file_path, File.READ) == OK:
			var json_data = file.get_as_text()
			file.close()  # Close the file after reading
			existing_data = parse_json(json_data)
			if existing_data == null:
				existing_data = {}#	if GameState.transition_source != "LoadButton":
#		print("Not load")
#		puzzle = state["puzzle"].duplicate(true)
#		penciled_digits = state["penciled_digits"].duplicate(true)
#		ButtonManager.update_button_state_in_file(save_button_name + "_save", state)
#		update_cells()
#		_draw_grid()
		
#if GameState.transition_source == "LoadButton":

		for key in new_state.keys():
			existing_data[key] = new_state[key]

		data_to_store = to_json(existing_data)
	else:
		return false  # Invalid type passed

	# Open the file for writing
	if file.open(file_path, File.WRITE) == OK:
		file.store_line(data_to_store)
		file.close()
		return true
	else:
		return false

func _on_load_button_pressed(button):
	# Set the save_button_name in GameState
	GameState.save_button_name = button.text
	GameState.history_stack = []

	# Extract difficulty and time_string from button text
	var button_text_parts = button.text.split(" - ")
	var difficulty = button_text_parts[0] if button_text_parts.size() > 0 else "Unknown"
	var time_string = button_text_parts[1] if button_text_parts.size() > 1 else "Unknown"
	
	# Retrieve the saved state from the button's specific save file
	var file_path = "user://" + button.text + "_save.json"
	var history_file_path = "user://" + button.text + "_history.json"
	var file = File.new()

	# Load and parse JSON data from the save file
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		var json_data = file.get_as_text()
		file.close()
		var button_data = parse_json(json_data)

		if button_data:#	if GameState.transition_source != "LoadButton":
#		print("Not load")
#		puzzle = state["puzzle"].duplicate(true)
#		penciled_digits = state["penciled_digits"].duplicate(true)
#		ButtonManager.update_button_state_in_file(save_button_name + "_save", state)
#		update_cells()
#		_draw_grid()
		
#if GameState.transition_source == "LoadButton":
			# Handle current pointer
			if button_data.has("current_pointer"):
				GameState.current_pointer = int(button_data["current_pointer"])

			# Handle the original puzzle
			if button_data.has("puzzle"):
				var original_puzzle = button_data["puzzle"]
				# Convert each element of the retrieved puzzle to integer
				var converted_puzzle = []
				for row in original_puzzle:
					var converted_row = []
					for cell in row:
						converted_row.append(int(cell))
					converted_puzzle.append(converted_row)
				GameState.puzzle = converted_puzzle
			
			if button_data.has("penciled_digits"):
				GameState.penciled_digits = button_data["penciled_digits"]
			
			if button_data.has("number_source"):
				GameState.number_source = button_data["number_source"]

			if button_data.has("selected_cells"):
				var cells = []
				for cell_str in button_data["selected_cells"]:
					# Parse the string to extract x and y values
					var cell_parts = cell_str.substr(1, cell_str.length() - 2).split(", ")
					var x = int(cell_parts[0])
					var y = int(cell_parts[1])

					# Create a Vector2 object and add it to the cells array
					cells.append(Vector2(x, y))

				# Assign the array of Vector2 objects to GameState.selected_cells
				GameState.selected_cells = cells

			if file.file_exists(history_file_path):
				file.open(history_file_path, File.READ)
				var history_json_data = file.get_as_text()
				file.close()
				var history_data = parse_json(history_json_data)

				if history_data:
					for state in history_data:
						# Handle current_pointer
						var current_pointer = int(state["current_pointer"])

						# Handle number_source
						var number_source = state["number_source"]

						# Handle penciled_digits
						var penciled_digits = state["penciled_digits"]

						# Handle puzzle
						var original_puzzle = state["puzzle"]
						# Convert each element of the retrieved puzzle to integer
						var converted_puzzle = []
						for row in original_puzzle:
							var converted_row = []
							for cell in row:
								converted_row.append(int(cell))
							converted_puzzle.append(converted_row)
						var puzzle = converted_puzzle

						# Handle selected_cell
#						var cell_string = state["selected_cell"]
#						var cell_vector = Vector2.ZERO  # Default to ZERO Vector2

						# Remove parentheses and split the string by comma
#						cell_string = cell_string.trim_prefix("(").trim_suffix(")")
#						var parts = cell_string.split(", ")
#						if parts.size() == 2:
#							cell_vector = Vector2(int(parts[0]), int(parts[1]))
#
#						var selected_cell = cell_vector

						# Handle selected_cells (if they are saved as strings)
						var cells = []
						for cell_str in state["selected_cells"]:
							# Parse the string to extract x and y values
							var cell_parts = cell_str.substr(1, cell_str.length() - 2).split(", ")
							var x = int(cell_parts[0])
							var y = int(cell_parts[1])

							# Create a Vector2 object and add it to the cells array
							cells.append(Vector2(x, y))

							# Assign the array of Vector2 objects to GameState.selected_cells
							var selected_cells = cells
							#print("Type of selected_cells: " + str(typeof(selected_cells))

						GameState.history_stack.append(state)

				else:
					print("Failed to load history data from file: ", history_file_path)
			else:
				print("History file not found: ", history_file_path)

			# Transition to game scene
			var current_scene_tree = Engine.get_main_loop()
			if current_scene_tree:
				GameState.transition_source = "LoadButton"
				current_scene_tree.change_scene("res://Sudoku/Scenes/Sudoku.tscn")
		else:
			print("Failed to parse JSON from file: ", file_path)
	else:
		print("No save file found for button: ", button.text)

func _on_delete_button_pressed(container, save_file_name, delete_button):
	# Base path for the save files
	var base_path = "user://" + save_file_name

	# Paths for the specific button's save file and history file
	var save_path = base_path + "_save.json"
	var history_path = base_path + "_history.json"
	var dir = Directory.new()

	# Delete the save file
	if dir.file_exists(save_path):
		var error = dir.remove(save_path)
		if error != OK:
			print("Failed to delete save file: ", save_path)

	# Delete the history file
	if dir.file_exists(history_path):
		var error = dir.remove(history_path)
		if error != OK:
			print("Failed to delete history file: ", history_path)

	# Remove the associated buttons and the delete button itself
	for child in container.get_children():
		if child is Button and child.text == save_file_name:
			container.remove_child(child)
			break  # Break after removing the button to avoid invalid iterator

	# If the delete button is part of the container, remove it
	if delete_button and delete_button.get_parent() == container:
		container.remove_child(delete_button)

func load_buttons_state(grid_container, button_identifiers):
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/Old-Standard-TT/OldStandard-Regular.ttf")
	font.size = 85

	for button_identifier in button_identifiers:
		var file_path = "user://" + button_identifier + "_save.json"
		var file = File.new()
		if file.file_exists(file_path):
			var error = file.open(file_path, File.READ)
			if error != OK:
				print("Failed to open file for button: ", button_identifier, ", Error: ", file.get_error())
				continue

			var json_data = file.get_as_text()
			file.close()
			var button_data = parse_json(json_data)

			if button_data:
				# Use the button_identifier as the button text
				var button_text = button_identifier

				if not button_exists(grid_container, button_text):
					# Create and configure the load button
					var load_button = Button.new()
					load_button.text = button_text
					load_button.rect_min_size = Vector2(200, 50)
					load_button.add_font_override("font", font)

					# Reconnect the 'pressed' signal for the load button
					load_button.connect("pressed", self, "_on_load_button_pressed", [load_button])
					grid_container.add_child(load_button)

					# Create and connect a delete button
					var delete_button = Button.new()
					# Check the solved status and set delete button text
					delete_button.text = "O" if button_data["solved"] else "X"
					delete_button.rect_min_size = Vector2(100, 50)
					delete_button.add_font_override("font", font)  # Apply the same font
					delete_button.connect("pressed", self, "_on_delete_button_pressed", [grid_container, button_text, delete_button])
					grid_container.add_child(delete_button)
			else:
				print("Invalid data in file for: ", button_identifier)
		else:
			print("File not found: ", file_path)

func button_exists(grid_container, button_text):
	for child in grid_container.get_children():
		if child is Button and child.text == button_text:
			return true
	return false
