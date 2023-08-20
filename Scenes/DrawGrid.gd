#DrawGrid
extends Control

var CellScene = preload("res://Scenes/Cell.tscn")
var puzzle = Global.puzzle
# Define the size of each cell and the total grid size
var cell_size = 64
var grid_size = 9
# Variables for scaled cell size and starting position
var scaled_cell_size
var start_x
var start_y
var grid_width
var grid_height
var margin = 50  # Define a margin for the border
# Variable to keep track of the selected cell
var selected_cell = Vector2(-1, -1)
var number_source = []

func _ready():
	# Call the draw function when the node is ready
	_calculate_grid_parameters()
	_draw_grid()
	# Connect the size_changed signal
	self.connect("resized", self, "_on_size_changed")
	# Instantiate and add the Cell scene
	for i in range(grid_size):
		for j in range(grid_size):
			var cell = CellScene.instance()
			cell.position = Vector2(start_x + j * scaled_cell_size + scaled_cell_size / 2, start_y + i * scaled_cell_size + scaled_cell_size / 2)
			if puzzle[i][j] != 0:
				cell.set_number(puzzle[i][j], "game")
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
	# Calculate the scaling factor based on the window width
	var scale_factor = window_width / (cell_size * grid_size)
	# Calculate the scaled cell size
	scaled_cell_size = cell_size * scale_factor
	# Calculate the total grid width and height
	grid_width = scaled_cell_size * grid_size
	grid_height = scaled_cell_size * grid_size
	# Calculate the starting position to center the grid with the margin
	start_x = (OS.get_window_size().x - grid_width) / 2
	start_y = (OS.get_window_size().y / 2 - grid_height) / 2 + margin

func _draw_grid():
	# Request an update to redraw the canvas
	self.update()

func _draw():
	# Draw the 9x9 grid using the scaled cell size and starting position
	for i in range(grid_size + 1):
		# Vertical lines
		var start_point = Vector2(start_x + i * scaled_cell_size, start_y)
		var end_point = Vector2(start_x + i * scaled_cell_size, start_y + grid_size * scaled_cell_size)
		draw_line(start_point, end_point, Color(0, 0, 0), 2)
		
		# Highlight the thicker border lines for 3x3 boxes
		if i % 3 == 0:
			draw_line(start_point, end_point, Color(0, 0, 0), 4)
		# Horizontal lines
		start_point = Vector2(start_x, start_y + i * scaled_cell_size)
		end_point = Vector2(start_x + grid_size * scaled_cell_size, start_y + i * scaled_cell_size)
		draw_line(start_point, end_point, Color(0, 0, 0), 2)
		
		# Highlight the thicker border lines for 3x3 boxes
		if i % 3 == 0:
			draw_line(start_point, end_point, Color(0, 0, 0), 4)

	# Draw the numbers from the puzzle
	for i in range(grid_size):
		for j in range(grid_size):
			var cell_name = "cell_" + str(i) + "_" + str(j)
			var cell = get_node_or_null(cell_name)
			
			if not cell:
				cell = CellScene.instance()
				cell.name = cell_name
				cell.position = Vector2(start_x + j * scaled_cell_size + scaled_cell_size / 2, start_y + i * scaled_cell_size + scaled_cell_size / 2)
				add_child(cell)
				cell.connect("cell_clicked", self, "_on_cell_clicked", [Vector2(i, j)])
			
			if puzzle[i][j] != 0:
				cell.set_number(puzzle[i][j], "game")

func _input(event):
	# Detect cell clicks
	if event is InputEventMouseButton and event.pressed:
		var cell_y = int((event.position.x - start_x) / scaled_cell_size)
		var cell_x = int((event.position.y - start_y) / scaled_cell_size)
		
		# Check if the click is within the grid bounds
		if 0 <= cell_x and cell_x < grid_size and 0 <= cell_y and cell_y < grid_size:
			selected_cell = Vector2(cell_x, cell_y)
			print("Selected cell: ", selected_cell)

	# Input numbers
	if selected_cell != Vector2(-1, -1) and event is InputEventKey and event.pressed:
		# Check if the selected cell's number was not placed by the game
		if number_source[selected_cell.x][selected_cell.y] == "player":
			for i in range(1, 10):
				if event.scancode == KEY_1 + i - 1:
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
	# Recalculate the grid parameters and redraw the grid
	_calculate_grid_parameters()
	_draw_grid()

func _on_cell_clicked(cell_position):
	print("Cell clicked at position: ", cell_position)

func update_puzzle():
	puzzle = Global.puzzle
	_draw_grid()
