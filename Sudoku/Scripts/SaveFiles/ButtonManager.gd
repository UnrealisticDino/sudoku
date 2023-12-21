#ButtonManager
extends Node
var original_puzzle = Global.puzzle

# Function to add a load button
func add_load_button(grid_container, difficulty):
	var current_datetime = OS.get_datetime_from_unix_time(OS.get_unix_time())
	var time_string = "%d-%02d-%02d %02d:%02d" % [current_datetime.year, current_datetime.month, current_datetime.day, current_datetime.hour, current_datetime.minute]
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
	delete_button.text = "Delete"
	delete_button.rect_min_size = Vector2(100, 50)

	# Save the state of the buttons
	save_buttons_state(grid_container)

	return load_button.text

func save_buttons_state(grid_container):
	var buttons_data = []
	for child in grid_container.get_children():
		if child is Button:
			var button_state = get_button_state(child.text)

			buttons_data.append({"text": child.text, "state": button_state, "original_puzzle": Global.puzzle.duplicate(true)})

	var file = File.new()
	if file.open("user://saved_buttons.dat", File.WRITE) == OK:
		# Serialize each button's data to JSON and write it to the file
		for button_data in buttons_data:
			var json_data = to_json(button_data) + "\n"
			file.store_string(json_data)
		file.close()

func get_button_state(button_text):
	# File path where the buttons' states are saved
	var file_path = "user://saved_buttons.dat"
	var file = File.new()

	# Check if the file exists
	if file.file_exists(file_path):
		# Open the file in read mode
		var error = file.open(file_path, File.READ)
		if error != OK:
			print("Failed to open file: ", file.get_error())
			return null

		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "":
				continue  # Skip empty lines

			var button_data = parse_json(line)
			if button_data == null:
				print("Failed to parse JSON from line.")
				continue

			if button_data.has("text") and button_data["text"] == button_text:
				file.close()  # Close the file before returning
				if button_data.has("state"):
					return button_data["state"]
				else:
					print("No state data found for button: ", button_text)
					return null

		file.close()  # Close the file if no matching button is found
		print("Button not found: ", button_text)
	else:
		print("File not found: ", file_path)

	return null

func get_original_puzzle(button_text: String) -> Array:
	var file = File.new()
	if file.file_exists("user://saved_buttons.dat") and file.open("user://saved_buttons.dat", File.READ) == OK:
		while not file.eof_reached():
			var line = file.get_line()
			var button_data = parse_json(line)
			if button_data["text"] == button_text:
				file.close()
				return button_data["original_puzzle"]
		file.close()
	return []

func _on_load_button_pressed(button, difficulty, time_string):
	print("Load button pressed for difficulty: ", difficulty, " at time: ", time_string)

	# Retrieve the original puzzle associated with the button
	var original_puzzle = ButtonManager.get_original_puzzle(button.text)
	if original_puzzle:
		print("Retrieved Puzzle: ", original_puzzle)

		# Convert each element of the retrieved puzzle to integer
		var converted_puzzle = []
		for row in original_puzzle:
			var converted_row = []
			for cell in row:
				converted_row.append(int(cell))
			converted_puzzle.append(converted_row)

		# Assign the converted puzzle to the global variable
		Global.puzzle = converted_puzzle

		# Get the main loop for the scene change
		var current_scene_tree = Engine.get_main_loop()
		if current_scene_tree:
			current_scene_tree.change_scene("res://Sudoku/Scenes/Sudoku.tscn")
	else:
		print("No original puzzle found for button: ", button.text)

func print_puzzle_types(puzzle: Array, name: String):
	print(name + " Types:")
	for row in puzzle:
		var row_types = []
		for cell in row:
			row_types.append(typeof(cell))
		print(row_types)

func print_puzzle_structure(puzzle: Array, name: String):
	print(name + " Structure: " + str(puzzle.size()) + " rows")
	for row in puzzle:
		print("Row length: " + str(row.size()))

func _on_delete_button_pressed(container, save_file_name, delete_button):
	# Remove the save data file
	var save_path = "user://%s.dat" % save_file_name
	var file = File.new()
	
	if file.file_exists(save_path):
		if file.open(save_path, File.READ) == OK:
			file.close()
			file.remove(save_path)
	
	# Remove the associated buttons and the delete button itself
	for child in container.get_children():
		if child is Button:
			if child.text == save_file_name:
				container.remove_child(child)
	
	container.remove_child(delete_button)
	 
	# Save the updated button state
	save_buttons_state(container)

func load_buttons_state(grid_container):
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/Old-Standard-TT/OldStandard-Regular.ttf")
	font.size = 50

	var file = File.new()
	if file.file_exists("user://saved_buttons.dat"):
		var error = file.open("user://saved_buttons.dat", File.READ)
		if error != OK:
			print("Failed to open file: ", file.get_error())
			return

		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "":
				continue  # Skip empty lines

			var button_data = parse_json(line)
			if button_data == null:
				print("Failed to parse JSON from line.")
				continue

			if not button_exists(grid_container, button_data["text"]):
				# Create and configure the load button
				var load_button = Button.new()
				load_button.text = button_data["text"]
				load_button.rect_min_size = Vector2(200, 50)
				load_button.add_font_override("font", font)

				# Extract difficulty and time_string from the button text
				var parsed_data = parse_button_text(load_button.text)
				var difficulty = parsed_data[0]
				var time_string = parsed_data[1]

				# Reconnect the 'pressed' signal for the load button
				var connection_result = load_button.connect("pressed", self, "_on_load_button_pressed", [load_button, difficulty, time_string])
				if connection_result != OK:
					print("Failed to reconnect load button: ", connection_result)

				grid_container.add_child(load_button)

				# Create and connect a delete button
				var delete_button = Button.new()
				delete_button.text = "Delete"
				delete_button.rect_min_size = Vector2(100, 50)
				delete_button.connect("pressed", self, "_on_delete_button_pressed", [grid_container, button_data["text"], delete_button])
				grid_container.add_child(delete_button)

		file.close()
	else:
		print("File not found: user://saved_buttons.dat")

# Helper function to parse difficulty and time from button text
func parse_button_text(button_text):
	var parts = button_text.split(" - ")
	if parts.size() >= 2:
		var difficulty = parts[0]
		var time_string = parts[1]
		return [difficulty, time_string]
	else:
		return ["Unknown", "Unknown"]

func update_button_state_in_file(button_text, new_state):
	var file_path = "user://saved_buttons.dat"
	var file = File.new()
	var updated = false
	var new_file_content = ""

	if file.file_exists(file_path):
		var error = file.open(file_path, File.READ)
		if error != OK:
			print("Failed to open file: ", file.get_error())
			return false

		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line == "":
				continue  # Skip empty lines

			var button_data = parse_json(line)
			if button_data == null:
				print("Failed to parse JSON from line.")
				continue

			if button_data.has("text") and button_data["text"] == button_text:
				button_data["state"] = new_state
				updated = true

			new_file_content += to_json(button_data) + "\n"

		file.close()
	else:
		print("File not found: ", file_path)
		return false

	if updated:
		var write_error = file.open(file_path, File.WRITE)
		if write_error != OK:
			print("Failed to open file for writing: ", file.get_error())
			return false

		file.store_string(new_file_content)
		file.close()
		return true

	return false

func save_buttons_data(buttons_data):
	var file = File.new()
	if file.open("user://saved_buttons.dat", File.WRITE) == OK:
		file.store_var(buttons_data)
		file.close()

func load_buttons_data():
	var file = File.new()
	var buttons_data = []
	if file.file_exists("user://saved_buttons.dat"):
		var error = file.open("user://saved_buttons.dat", File.READ)
		if error != OK:
			print("Failed to open file for reading: ", file.get_error())
			return buttons_data  # Return an empty array

		buttons_data = parse_json(file.get_as_text())
		file.close()

		if buttons_data == null:
			print("Failed to parse JSON from file.")
			return []

	return buttons_data

func button_exists(grid_container, button_text):
	for child in grid_container.get_children():
		if child is Button and child.text == button_text:
			return true
	return false
