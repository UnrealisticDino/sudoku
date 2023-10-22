#DrawGrid
extends Control

var CellScene = preload("res://Scenes/Cell.tscn")
var puzzle = Global.puzzle
var cell_size = 64
var grid_size = 9
var scaled_cell_size
var start_x
var start_y
var grid_width
var grid_height
var margin = 50
var selected_cell = Global.selected_cell
var number_source = []
var digit_scale_factor = 0.7
var selected_cells = Global.selected_cells
var grid_color = Global.grid_lines_color
var selected_cell_color = Global.selected_cell_color
var identical_digits_color = selected_cell_color.linear_interpolate(Color(0.5, 0.5, 1, 0.5), 0.5)  # Derived color with added transparency
var is_shift_pressed = false
var pencil_mode_key = KEY_SHIFT
var is_pencil_mode = false
var penciled_digits = []
var highlighted_cells = []
var undo_stack = []
var redo_stack = []
var mouse_button_down = false

# Your current game state variables
var current_puzzle = []
var current_selected_cells = []
var current_penciled_digits = []

func _ready():
	# Call the draw function when the node is ready
	_calculate_grid_parameters()
	_draw_grid()
	
	# Connect the size_changed signal of the main viewport
	get_viewport().connect("size_changed", self, "_on_size_changed")
	
	# Instantiate and add the Cell scene
	for i in range(grid_size):
		for j in range(grid_size):
			var cell = CellScene.instance()
			cell.position = Vector2(start_x + j * scaled_cell_size + scaled_cell_size / 2, start_y + i * scaled_cell_size + scaled_cell_size / 2)
			add_child(cell)
			cell.connect("cell_clicked", self, "_on_cell_clicked", [Vector2(i, j)])

	# Initialize the number_source array
	for i in range(grid_size):
		var row = []
		for j in range(grid_size):
			if puzzle[i][j] != 0:
				row.append("game")
			else:
				row.append("player")
		number_source.append(row)
		
	# Initialize the penciled_digits array
	for i in range(grid_size):
		var row = []
		for j in range(grid_size):
			row.append([])  # Each cell starts with an empty array for penciled digits
		Global.penciled_digits.append(row)

func _calculate_grid_parameters():
	# Get the window size
	var window_width = OS.get_window_size().x
	var window_height = OS.get_window_size().y
	
	# Calculate the available width, considering the margins
	var available_width = window_width - 2 * margin
	
	# The size of the grid should be the minimum of the available width and the window height
	var grid_dimension = min(available_width, window_height)
	
	# Calculate the scaled cell size
	scaled_cell_size = grid_dimension / grid_size
	
	# Calculate the total grid width and height (they will be the same since it's a square)
	grid_width = scaled_cell_size * grid_size
	grid_height = grid_width  # Since it's a square
	
	# Calculate the starting position to center the grid horizontally and maintain equal distance from the top
	start_x = (window_width - grid_width) / 2
	start_y = margin

func _draw_grid():
	self.update()

func _draw():
	# Highlight the selected cell
	if selected_cell != Vector2(-1, -1):
		var cell_pos = Vector2(start_x + selected_cell.y * scaled_cell_size, start_y + selected_cell.x * scaled_cell_size)
		draw_rect(Rect2(cell_pos, Vector2(scaled_cell_size, scaled_cell_size)), selected_cell_color)

	# Highlight all selected cells
	for cell in selected_cells:
		var cell_pos = Vector2(start_x + cell.y * scaled_cell_size, start_y + cell.x * scaled_cell_size)
		draw_rect(Rect2(cell_pos, Vector2(scaled_cell_size, scaled_cell_size)), selected_cell_color)

	# Highlight all identical digits if the setting is turned on
	if Global.highlight_identical_digits:
		for cell in highlighted_cells:
			var cell_pos = Vector2(start_x + cell.y * scaled_cell_size, start_y + cell.x * scaled_cell_size)
			draw_rect(Rect2(cell_pos, Vector2(scaled_cell_size, scaled_cell_size)), identical_digits_color)

	# Drawing grid lines
	for i in range(grid_size + 1):
		var start_point = Vector2(start_x + i * scaled_cell_size, start_y)
		var end_point = Vector2(start_x + i * scaled_cell_size, start_y + grid_size * scaled_cell_size)
		draw_line(start_point, end_point, grid_color, 2)
		if i % 3 == 0:
			draw_line(start_point, end_point, grid_color, 4)
		start_point = Vector2(start_x, start_y + i * scaled_cell_size)
		end_point = Vector2(start_x + grid_size * scaled_cell_size, start_y + i * scaled_cell_size)
		draw_line(start_point, end_point, grid_color, 2)
		if i % 3 == 0:
			draw_line(start_point, end_point, grid_color, 4)

	# Draw cells and penciled digits
	for i in range(grid_size):
		for j in range(grid_size):
			var cell_name = "cell_" + str(i) + "_" + str(j)
			var cell = get_node_or_null(cell_name)
			
			# If the cell doesn't exist, instantiate it
			if not cell:
				cell = CellScene.instance()
				cell.name = cell_name
				add_child(cell)
				cell.connect("cell_clicked", self, "_on_cell_clicked", [Vector2(i, j)])
				
				# Only set the number if the cell is newly created
				if puzzle[i][j] != 0:
					cell.set_number(puzzle[i][j], number_source[i][j])
			
			# Update the position and scale of the cell based on the new parameters
			cell.position = Vector2(start_x + j * scaled_cell_size + scaled_cell_size / 2, start_y + i * scaled_cell_size + scaled_cell_size / 2)
			cell.scale = Vector2(scaled_cell_size / cell_size, scaled_cell_size / cell_size) * digit_scale_factor
			# Clear existing penciled digits
			cell.clear_pencil_digits()
			# Draw penciled digits for the cell
			var cell_pencils = Global.penciled_digits[i][j]
			for k in range(len(cell_pencils)):
				var digit = cell_pencils[k]
				# Calculate position for the penciled digit in a 3x3 grid layout
				var row_offset = (digit - 1) / 3
				var col_offset = (digit - 1) % 3
				var pencil_position = Vector2(start_x + j * scaled_cell_size + col_offset * (scaled_cell_size / 3), start_y + i * scaled_cell_size + row_offset * (scaled_cell_size / 3))
				cell.set_pencil_digit(digit, true)  # true indicates that you want to show the digit

func _process(delta):
	if !Global.hint and mouse_button_down:  # Added the !Global.hint condition
		var mouse_position = get_global_mouse_position()
		
		# Add the condition here to check if the mouse is within the grid boundaries
		if (start_x <= mouse_position.x) and (mouse_position.x <= start_x + grid_width) and (start_y <= mouse_position.y) and (mouse_position.y <= start_y + grid_height):
			
			for i in range(grid_size):
				for j in range(grid_size):
					var cell_name = "cell_" + str(i) + "_" + str(j)
					var cell = get_node_or_null(cell_name)
					if cell and cell.get_rect().has_point(mouse_position):
						var cell_vector = Vector2(i, j)
						if !selected_cells.has(cell_vector):
							selected_cells.append(cell_vector)

			_draw_grid()  # Redraw the grid to reflect the changes

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_button_down = true
		else:
			mouse_button_down = false

	# Check for shift key press or release
	if event is InputEventKey:
		if event.scancode == pencil_mode_key:
			is_shift_pressed = event.pressed
			print("Shift key state: ", is_shift_pressed)
	
	if event is InputEventKey and event.pressed:
		if event.control:
			if event.scancode == KEY_Z:
				undo()
			elif event.scancode == KEY_Y:
				redo()

	# Check for mouse click to select a cell
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked at: ", event.position)
		print("Grid boundaries: x(", start_x, ", ", start_x + grid_width, ") y(", start_y, ", ", start_y + grid_height, ")")
		
		if (start_x <= event.position.x) and (event.position.x <= start_x + grid_width) and (start_y <= event.position.y) and (event.position.y <= start_y + grid_height):
			var cell_y = int((event.position.x - start_x) / scaled_cell_size)
			var cell_x = int((event.position.y - start_y) / scaled_cell_size)

			# Check if the click is within the grid boundaries
			if 0 <= cell_x and cell_x < grid_size and 0 <= cell_y and cell_y < grid_size:
				var new_selected_cell = Vector2(cell_x, cell_y)

				# If Shift key is pressed, add to the list; otherwise, clear the list and add the new cell
				if is_shift_pressed:
					if new_selected_cell in selected_cells:
						selected_cells.erase(new_selected_cell)
					else:
						selected_cells.append(new_selected_cell)
				else:
					selected_cells = [new_selected_cell]
				
				# Update the highlighted digits if the setting is turned on
				if Global.highlight_identical_digits:
					highlight_identical_digits(new_selected_cell)
			_draw_grid()

	# Check for Backspace key press to clear the selected cell
	if event is InputEventKey and event.pressed:
		if selected_cells.size() > 0:
			if event.scancode == KEY_BACKSPACE:
				print("Backspace pressed. Clearing selected cells.")
				clear_selected_cells()

	# Check for number key press
	if event is InputEventKey and event.pressed and selected_cells.size() > 0:  # Ensure the event is a key press
		#print("Number key pressed.")
		var is_pencil_mode = is_shift_pressed
		for selected_cell in selected_cells:
			var cell_name = "cell_" + str(selected_cell.x) + "_" + str(selected_cell.y)
			var selected_cell_node = get_node_or_null(cell_name)
			
			if number_source[selected_cell.x][selected_cell.y] == "player":
				for i in range(1, 10):
					if event.scancode == KEY_1 + i - 1 or event.scancode == KEY_KP_1 + i - 1:  # Check for both keyboard and numpad keys
						#print("Attempting to input number: ", i)
						if is_pencil_mode:  # Check if pencil mode is active
							toggle_pencil_digit(selected_cell, i)
						else:
							#print("Inputting number into cell.")
							input_number(selected_cell, i)
						break

func clear_selected_cells():
	for cell in selected_cells:
		var row = cell.x
		var col = cell.y
		
		# Check if the digit was placed by the player before clearing it
		if number_source[row][col] == "player":
			puzzle[row][col] = 0  # Clear the cell's value
			Global.penciled_digits[row][col] = []  # Clear any penciled digits for the cell
			var cell_name = "cell_" + str(row) + "_" + str(col)
			var selected_cell_node = get_node_or_null(cell_name)
			if selected_cell_node:
				selected_cell_node.clear_cell()  # Clear the visual representation of the cell
	
	highlighted_cells.clear()  # Clear the highlighted cells

func input_number(cell, number):
	print("cell == ", cell, "number == ", number)
	
	if number_source[cell.x][cell.y] != "player":
		print("Cannot overwrite a game-placed digit.")
		return

	save_state()  # Save the state before making changes
	if Global.hint:
		var new_selected_cell = cell
		selected_cells = [new_selected_cell]

	var col = cell.y
	var row = cell.x
	
	# Check if the digit being placed is the same as the one already in the cell
	if puzzle[row][col] == number:
		puzzle[row][col] = 0  # Remove the digit
		Global.penciled_digits[row][col] = []  # Clear any penciled digits for the cell
	else:
		puzzle[row][col] = number
		Global.penciled_digits[row][col] = []  # Clear any penciled digits for the cell
	
	var cell_name = "cell_" + str(row) + "_" + str(col)
	print("cell name = ", cell_name)
	
	var selected_cell_node = get_node_or_null(cell_name)
	print("selected cell node ", selected_cell_node)
	
	if selected_cell_node:
		print("puzzle =", puzzle,"\nrow =", row,"\ncol =", col)
		for i in range(1, 10):  # Clear the visual representation of penciled digits
			selected_cell_node.set_pencil_digit(i, false)
		selected_cell_node.set_number(puzzle[row][col], "player")
	
	# Update the highlighted digits if the setting is turned on
	if Global.highlight_identical_digits:
		highlight_identical_digits(cell)
	
	Global.hint = false
	_draw_grid()

func _on_size_changed():
	# Recalculate the grid parameters
	_calculate_grid_parameters()
	
	# Reposition and scale all game elements based on the new parameters
	for i in range(grid_size):
		for j in range(grid_size):
			var cell_name = "cell_" + str(i) + "_" + str(j)
			var cell = get_node_or_null(cell_name)
			if cell:
				cell.position = Vector2(start_x + j * scaled_cell_size + scaled_cell_size / 2, start_y + i * scaled_cell_size + scaled_cell_size / 2)
				# If the Cell scene has a scale property, adjust it based on the new scaled_cell_size
				cell.scale = Vector2(scaled_cell_size / cell_size, scaled_cell_size / cell_size) * digit_scale_factor

func update_puzzle():
	puzzle = Global.puzzle
	_draw_grid()

func highlight_identical_digits(cell):
	highlighted_cells.clear()
	var selected_value = puzzle[cell.x][cell.y]
	
	# If the selected cell is empty, return early without highlighting other cells
	if selected_value == 0:
		return

	for i in range(grid_size):
		for j in range(grid_size):
			# Check if the cell has an identical digit and is not the selected cell
			if puzzle[i][j] == selected_value and Vector2(i, j) != cell:
				highlighted_cells.append(Vector2(i, j))

func toggle_pencil_digit(cell, digit):
	print("Toggling pencil digit: ", digit)
	# Check if the cell is empty before allowing penciling in digits
	if puzzle[cell.x][cell.y] == 0:
		save_state()  # Save the state before making changes
		var current_pencils = Global.penciled_digits[cell.x][cell.y]
		if digit in current_pencils:
			var new_pencils = []
			for d in current_pencils:
				if d != digit:
					new_pencils.append(d)
			current_pencils = new_pencils  # Remove the penciled-in digit
			#print("Removed pencil digit: ", digit)
		else:
			current_pencils.append(digit)  # Add the penciled-in digit
			#print("Added pencil digit: ", digit)
		Global.penciled_digits[cell.x][cell.y] = current_pencils
		_draw_grid()  # Redraw the grid to reflect the changes

func undo():
	print("Undo stack before undo: ", undo_stack)
	print("Redo stack before undo: ", redo_stack)
	if undo_stack.size() > 0:  # Changed from > 1 to > 0
		var current_state = {
			"puzzle": puzzle.duplicate(true),
			"selected_cells": selected_cells.duplicate(true),
			"penciled_digits": Global.penciled_digits.duplicate(true),
		}
		redo_stack.append(current_state)
		
		var last_state = undo_stack.pop_back()
		load_state(last_state)
		print("Undo successful")
	else:
		print("Undo stack is empty. Cannot undo.")
	print("Undo stack after undo: ", undo_stack)
	print("Redo stack after undo: ", redo_stack)

func redo():
	print("Undo stack before redo: ", undo_stack)
	print("Redo stack before redo: ", redo_stack)
	if redo_stack.size() > 0:
		var last_state = redo_stack.pop_back()
		undo_stack.append({
			"puzzle": puzzle.duplicate(true),
			"selected_cells": selected_cells.duplicate(true),
			"penciled_digits": Global.penciled_digits.duplicate(true),
		})
		load_state(last_state)
		print("Redo successful")
	else:
		print("Redo stack is empty. Cannot redo.")
	print("Undo stack after redo: ", undo_stack)
	print("Redo stack after redo: ", redo_stack)

func save_state():
	if puzzle is Array and selected_cells is Array and Global.penciled_digits is Array:
		var state = {
			"puzzle": puzzle.duplicate(true),
			"selected_cells": selected_cells.duplicate(true),
			"penciled_digits": Global.penciled_digits.duplicate(true),
			# Add other game state variables here
		}
		undo_stack.append(state)
		redo_stack.clear()

func load_state(state):
	if state.has("puzzle") and state.has("selected_cells") and state.has("penciled_digits"):
		puzzle = state["puzzle"].duplicate(true)
		selected_cells = state["selected_cells"].duplicate(true)
		Global.penciled_digits = state["penciled_digits"].duplicate(true)
		# Load other game state variables here
		update_cells()  # Update the visual elements
		_draw_grid()  # Redraw the grid to reflect the changes

func update_cells():
	for i in range(grid_size):
		for j in range(grid_size):
			var cell_name = "cell_" + str(i) + "_" + str(j)
			var cell = get_node_or_null(cell_name)
			if cell:
				cell.set_number(puzzle[i][j], number_source[i][j])
