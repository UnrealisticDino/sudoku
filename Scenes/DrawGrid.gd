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
var selected_cell = Vector2(-1, -1)
var number_source = []
var digit_scale_factor = 0.7
var selected_cells = []
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
		penciled_digits.append(row)

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

	# Highlight the selected cell (New Feature)
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

	# Draw cells and penciled digits (New Feature)
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

			# Draw penciled digits for the cell
			var cell_pencils = penciled_digits[i][j]
			for k in range(len(cell_pencils)):
				var digit = cell_pencils[k]
				# Calculate position for the penciled digit in a 3x3 grid layout
				var row_offset = (digit - 1) / 3
				var col_offset = (digit - 1) % 3
				var pencil_position = Vector2(start_x + j * scaled_cell_size + col_offset * (scaled_cell_size / 3), start_y + i * scaled_cell_size + row_offset * (scaled_cell_size / 3))

				cell.set_pencil_digit(digit, true)  # true indicates that you want to show the digit

func _input(event):
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
		print("Mouse clicked at position: ", event.position)
		var cell_y = int((event.position.x - start_x) / scaled_cell_size)
		var cell_x = int((event.position.y - start_y) / scaled_cell_size)
		
		# Check if the click is within the grid boundaries
		if 0 <= cell_x and cell_x < grid_size and 0 <= cell_y and cell_y < grid_size:
			var new_selected_cell = Vector2(cell_x, cell_y)
			print("New selected cell: ", new_selected_cell)
			
			# If Shift key is pressed, add to the list; otherwise, clear the list and add the new cell
			if is_shift_pressed:
				if new_selected_cell in selected_cells:
					print("Removing cell from selected_cells: ", new_selected_cell)
					selected_cells.erase(new_selected_cell)
				else:
					print("Adding cell to selected_cells: ", new_selected_cell)
					selected_cells.append(new_selected_cell)
			else:
				print("Setting selected_cells to only the new cell: ", new_selected_cell)
				selected_cells = [new_selected_cell]
			
			# Update the highlighted digits if the setting is turned on
			if Global.highlight_identical_digits:
				highlight_identical_digits(new_selected_cell)
			
			_draw_grid()  # Redraw the grid to update the highlighted cells

	# Check for Backspace key press to clear the selected cell
	if event is InputEventKey and event.pressed:
		print("Key pressed: ", event.scancode)
		if selected_cells.size() > 0:
			if event.scancode == KEY_BACKSPACE:
				print("Backspace pressed. Clearing selected cells.")
				clear_selected_cells()

	# Check for number key press
	if event is InputEventKey and event.pressed and selected_cells.size() > 0:  # Ensure the event is a key press
		print("Number key pressed.")
		var is_pencil_mode = is_shift_pressed
		for selected_cell in selected_cells:
			var cell_name = "cell_" + str(selected_cell.x) + "_" + str(selected_cell.y)
			var selected_cell_node = get_node_or_null(cell_name)
			
			if number_source[selected_cell.x][selected_cell.y] == "player":
				for i in range(1, 10):
					if event.scancode == KEY_1 + i - 1 or event.scancode == KEY_KP_1 + i - 1:  # Check for both keyboard and numpad keys
						print("Attempting to input number: ", i)
						if is_pencil_mode:  # Check if pencil mode is active
							toggle_pencil_digit(selected_cell, i)
						else:
							print("Inputting number into cell.")
							input_number(selected_cell, i)
						break

func clear_selected_cells():
	for cell in selected_cells:
		var row = cell.x
		var col = cell.y
		
		# Check if the digit was placed by the player before clearing it
		if number_source[row][col] == "player":
			puzzle[row][col] = 0  # Clear the cell's value
			penciled_digits[row][col] = []  # Clear any penciled digits for the cell
			var cell_name = "cell_" + str(row) + "_" + str(col)
			var selected_cell_node = get_node_or_null(cell_name)
			if selected_cell_node:
				selected_cell_node.clear_cell()  # Clear the visual representation of the cell
	
	selected_cells.clear()
	highlighted_cells.clear()  # Clear the highlighted cells

	_draw_grid()  # Redraw the grid to reflect the changes

func input_number(cell, number):
	save_state()  # Save the state before making changes
	var col = cell.y
	var row = cell.x
	puzzle[row][col] = number
	penciled_digits[row][col] = []  # Clear any penciled digits for the cell
	var cell_name = "cell_" + str(row) + "_" + str(col)
	var selected_cell_node = get_node_or_null(cell_name)
	if selected_cell_node:
		for i in range(1, 10):  # Clear the visual representation of penciled digits
			selected_cell_node.set_pencil_digit(i, false)
		selected_cell_node.set_number(number, "player")
	
	# Update the highlighted digits if the setting is turned on
	if Global.highlight_identical_digits:
		highlight_identical_digits(cell)
	
	_draw_grid()  # Redraw the grid to reflect the changes

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
	
	# Redraw the grid
	_draw_grid()

func _on_cell_clicked(cell_position):
	selected_cell = cell_position 
	selected_cells = [cell_position]
	_draw_grid()

	# Update the highlighted digits if the setting is turned on
	if Global.highlight_identical_digits:
		highlight_identical_digits(cell_position)

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
	save_state()  # Save the state before making changes
	if digit in penciled_digits[cell.x][cell.y]:
		penciled_digits[cell.x][cell.y].erase(digit)
	else:
		penciled_digits[cell.x][cell.y].append(digit)
	_draw_grid()

func save_state():
	undo_stack.append({
		"puzzle": puzzle.duplicate(true),
		"selected_cells": selected_cells.duplicate(true),
		"penciled_digits": penciled_digits.duplicate(true),
	})
	print("State saved: ", undo_stack[-1])

func undo():
	print("Undo stack before undo: ", undo_stack)
	print("Redo stack before undo: ", redo_stack)
	if undo_stack.size() > 0:
		var current_state = {
			"puzzle": puzzle.duplicate(true),
			"selected_cells": selected_cells.duplicate(true),
			"penciled_digits": penciled_digits.duplicate(true),
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
			"penciled_digits": penciled_digits.duplicate(true),
		})
		load_state(last_state)
		print("Redo successful")
	else:
		print("Redo stack is empty. Cannot redo.")
	print("Undo stack after redo: ", undo_stack)
	print("Redo stack after redo: ", redo_stack)

func load_state(state):
	puzzle = state["puzzle"].duplicate(true)
	selected_cells = state["selected_cells"].duplicate(true)
	penciled_digits = state["penciled_digits"].duplicate(true)
	update_cells()

func update_cells():
	for i in range(grid_size):
		for j in range(grid_size):
			var cell_name = "cell_" + str(i) + "_" + str(j)
			var cell = get_node_or_null(cell_name)
			if cell:
				cell.set_number(puzzle[i][j], number_source[i][j])
