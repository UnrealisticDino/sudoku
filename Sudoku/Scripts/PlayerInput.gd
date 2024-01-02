# PlayerInput.gd
extends Control

var SudokuSolver = preload("res://Sudoku/Scripts/SudokuSolver.gd").new()
var grid_cells = []
var scaled_cell_size = 220
var selected_cell_color = Global.selected_cell_color
var player_digit_color = Global.player_digit_color
onready var DrawGrid = get_tree().get_nodes_in_group("DrawGridGroup")[0]
var selected_cells = []

func _ready():
	add_child(SudokuSolver)
	
	# Initialize 3x3 grid with numbers 1-9
	for row in range(3):
		for col in range(3):
			var cell = Node2D.new()
			
			var highlight = ColorRect.new()
			highlight.rect_min_size = Vector2(scaled_cell_size, scaled_cell_size)
			highlight.color = selected_cell_color
			highlight.visible = false
			highlight.rect_position = Vector2(0, 0)  # Position it at the top-left corner of the cell
			cell.add_child(highlight)
			
			var sprite = Sprite.new()
			sprite.set_script(preload("res://Sudoku/Scripts/ImageDisplay.gd"))
			sprite.call("set_number", row * 3 + col + 1, "player")
			sprite.position = Vector2(scaled_cell_size / 2, scaled_cell_size / 2)  # Position it at the center of the cell
			cell.add_child(sprite)
			
			cell.position = Vector2(col * scaled_cell_size, row * scaled_cell_size)
			add_child(cell)
			grid_cells.append(cell)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed")
		get_tree().change_scene("res://Scenes/StartGame.tscn")
		
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/StartGame.tscn")
			return

	if event is InputEventMouseButton:
		var mouse_pos = event.position

		if event.pressed:
			# Handle cell selection
			for i in range(len(grid_cells)):
				var cell = grid_cells[i]
				var cell_rect = Rect2(cell.global_position, Vector2(scaled_cell_size, scaled_cell_size))
				
				if cell_rect.has_point(mouse_pos):
					# Calculate the digit based on the index in the grid_cells array
					var row = i / 3  # Integer division to get the row
					var col = i % 3  # Modulo to get the column
					var digit = row * 3 + col + 1  # Calculate the digit
					
					#print("Selected cell at row ", row, ", col ", col, " with digit ", digit)
					if digit != null:
						selected_cells = DrawGrid.selected_cells
						#print(selected_cells, digit)
						for selected_cell in selected_cells:
							DrawGrid.input_number(selected_cell, digit)  # Call the function with the digit
					else:
						print("Digit is null")
					
					selected_cells = cell
					selected_cells.get_child(0).visible = true  # Show the highlight of the selected cell
					break

		elif selected_cells:
			selected_cells.get_child(0).visible = false  # Hide the highlight of the selected cell
			selected_cells = null

func _draw():
	# Draw grid lines
	var grid_size = 3
	var start_x = 0
	var start_y = 0
	var grid_color = Global.grid_lines_color

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
