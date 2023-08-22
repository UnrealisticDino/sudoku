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
var selected_cell_color = Global.selected_cell_color
var identical_digits_color = selected_cell_color.linear_interpolate(Color(0.5, 0.5, 1, 0.5), 0.5)  # Derived color with added transparency

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

func _calculate_grid_parameters():
	var window_width = OS.get_window_size().x - 2 * margin
	var window_height = (OS.get_window_size().y / 2) - 2 * margin
	
	# Calculate the scaling factor based on both the window width and height
	var scale_factor_width = window_width / (cell_size * grid_size)
	var scale_factor_height = window_height / (cell_size * grid_size)
	
	# Use the smaller scale factor to ensure the grid fits both in width and height
	var scale_factor = min(scale_factor_width, scale_factor_height)
	
	# Calculate the scaled cell size
	scaled_cell_size = cell_size * scale_factor
	
	# Calculate the total grid width and height
	grid_width = scaled_cell_size * grid_size
	grid_height = scaled_cell_size * grid_size
	
	# Calculate the starting position to center the grid with the margin
	start_x = (OS.get_window_size().x - grid_width) / 2
	start_y = (OS.get_window_size().y / 2 - grid_height) / 2 + margin

func _draw_grid():
	self.update()

func _draw():
	for i in range(grid_size + 1):
		var start_point = Vector2(start_x + i * scaled_cell_size, start_y)
		var end_point = Vector2(start_x + i * scaled_cell_size, start_y + grid_size * scaled_cell_size)
		draw_line(start_point, end_point, Color(0, 0, 0), 2)
		if i % 3 == 0:
			draw_line(start_point, end_point, Color(0, 0, 0), 4)
		start_point = Vector2(start_x, start_y + i * scaled_cell_size)
		end_point = Vector2(start_x + grid_size * scaled_cell_size, start_y + i * scaled_cell_size)
		draw_line(start_point, end_point, Color(0, 0, 0), 2)
		if i % 3 == 0:
			draw_line(start_point, end_point, Color(0, 0, 0), 4)

	# Highlight the selected cell
	if selected_cell != Vector2(-1, -1):
		var cell_pos = Vector2(start_x + selected_cell.y * scaled_cell_size, start_y + selected_cell.x * scaled_cell_size)
		draw_rect(Rect2(cell_pos, Vector2(scaled_cell_size, scaled_cell_size)), selected_cell_color)

	# Highlight all identical digits if the setting is turned on
	if Global.highlight_identical_digits:
		print(selected_cells)
		for cell in selected_cells:
			var cell_pos = Vector2(start_x + cell.y * scaled_cell_size, start_y + cell.x * scaled_cell_size)
			draw_rect(Rect2(cell_pos, Vector2(scaled_cell_size, scaled_cell_size)), identical_digits_color)

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

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var cell_y = int((event.position.x - start_x) / scaled_cell_size)
		var cell_x = int((event.position.y - start_y) / scaled_cell_size)

		# Check if the click is within the grid boundaries
		if 0 <= cell_x and cell_x < grid_size and 0 <= cell_y and cell_y < grid_size:
			# Check if the click is within the actual grid area
			if event.position.x >= start_x and event.position.x <= start_x + grid_size * scaled_cell_size and \
			   event.position.y >= start_y and event.position.y <= start_y + grid_size * scaled_cell_size:
				selected_cell = Vector2(cell_x, cell_y)
				print("Selected cell: ", selected_cell)
				if Global.highlight_identical_digits:
					highlight_identical_digits(selected_cell)
				_draw_grid()  # Redraw the grid to update the highlighted cell

	if selected_cell != Vector2(-1, -1) and event is InputEventKey and event.pressed:
		if number_source[selected_cell.x][selected_cell.y] == "player":
			for i in range(1, 10):
				if event.scancode == KEY_1 + i - 1 or event.scancode == KEY_KP_1 + i - 1:  # Check for numpad keys
					input_number(selected_cell, i)
					break

func input_number(cell, number):
	var col = cell.y
	var row = cell.x
	puzzle[row][col] = number
	var cell_name = "cell_" + str(row) + "_" + str(col)
	var selected_cell_node = get_node_or_null(cell_name)
	if selected_cell_node:
		selected_cell_node.set_number(number, "player")

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
	print("Cell clicked at position: ", cell_position)
	selected_cell = cell_position
	_draw_grid()  # Redraw the grid to update the highlighted cell

func update_puzzle():
	puzzle = Global.puzzle
	_draw_grid()

func highlight_identical_digits(cell):
	selected_cells.clear()
	var selected_value = puzzle[cell.x][cell.y]
	for i in range(grid_size):
		for j in range(grid_size):
			if puzzle[i][j] == selected_value and Vector2(i, j) != cell:
				selected_cells.append(Vector2(i, j))
