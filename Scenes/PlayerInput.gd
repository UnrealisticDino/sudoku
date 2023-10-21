# PlayerInput.gd
extends Control

var SudokuSolver = preload("res://Scenes/SudokuSolver.gd").new()
var hint_box
var hint_box_outline
var hint_label
var is_hint_box_pressed = false
var grid_cells = []
var scaled_cell_size = 220
var selected_cell_color = Global.selected_cell_color
var player_digit_color = Global.player_digit_color
onready var DrawGrid = get_tree().get_nodes_in_group("DrawGridGroup")[0]
onready var selected_cells = DrawGrid.selected_cells

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
			sprite.set_script(preload("res://Scenes/ImageDisplay.gd"))
			sprite.call("set_number", row * 3 + col + 1, "player")
			sprite.position = Vector2(scaled_cell_size / 2, scaled_cell_size / 2)  # Position it at the center of the cell
			cell.add_child(sprite)
			
			cell.position = Vector2(col * scaled_cell_size, row * scaled_cell_size)
			add_child(cell)
			grid_cells.append(cell)
	
	# Create the outline for the hint box
	hint_box_outline = ColorRect.new()
	hint_box_outline.rect_position = Vector2(scaled_cell_size * 3 + 20, scaled_cell_size)
	hint_box_outline.rect_min_size = Vector2(204, 84)
	hint_box_outline.color = Global.grid_lines_color
	add_child(hint_box_outline)

	# Create the hint box
	hint_box = ColorRect.new()
	hint_box.rect_min_size = Vector2(200, 80)
	hint_box.rect_position = Vector2(4, 4)
	hint_box.rect_position = Vector2(2, 2)  # Position it within the outline
	hint_box_outline.add_child(hint_box)  # Add hint_box as a child of the outline

	# Create the label
	hint_label = Label.new()
	hint_label.text = "Hint"
	hint_label.rect_min_size = Vector2(200, 80)
	hint_label.align = Label.ALIGN_CENTER  # Center align horizontally
	hint_label.valign = Label.VALIGN_CENTER  # Center align vertically
	hint_label.add_color_override("font_color", Global.game_placed_digit_color)  # Set the text color to green
	hint_box.add_child(hint_label)
	hint_label.rect_scale = Vector2(2, 2)
	hint_label.rect_position = Vector2((hint_box.rect_min_size.x - hint_label.rect_min_size.x * hint_label.rect_scale.x) / 2, (hint_box.rect_min_size.y - hint_label.rect_min_size.y * hint_label.rect_scale.y) / 2)

func _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = event.position
		var is_mouse_over_hint_box = hint_box_outline.rect_global_position.x < mouse_pos.x and mouse_pos.x < hint_box_outline.rect_global_position.x + hint_box_outline.rect_min_size.x and hint_box_outline.rect_global_position.y < mouse_pos.y and mouse_pos.y < hint_box_outline.rect_global_position.y + hint_box_outline.rect_min_size.y

		if event.pressed:
			if is_mouse_over_hint_box:
				is_hint_box_pressed = true
				_swap_colors()
				_on_HintBox_pressed()
			else:
				# Handle cell selection
				for i in range(len(grid_cells)):
					var cell = grid_cells[i]
					var cell_rect = Rect2(cell.global_position, Vector2(scaled_cell_size, scaled_cell_size))
					
					if cell_rect.has_point(mouse_pos):
						# Calculate the digit based on the index in the grid_cells array
						var row = i / 3  # Integer division to get the row
						var col = i % 3  # Modulo to get the column
						var digit = row * 3 + col + 1  # Calculate the digit
						
						print("Selected cell at row ", row, ", col ", col, " with digit ", digit)
						if digit != null:
							selected_cells = DrawGrid.selected_cells
							print(selected_cells, digit)
							DrawGrid.input_number(selected_cells, digit)  # Call the function with the digit
						else:
							print("Digit is null")
						
						if selected_cells:
							selected_cells.get_child(0).visible = false  # Hide the highlight of the previously selected cell
						selected_cells = cell
						selected_cells.get_child(0).visible = true  # Show the highlight of the selected cell
						break
		else:
			# Handle mouse button release
			if is_hint_box_pressed and is_mouse_over_hint_box:
				is_hint_box_pressed = false
				_swap_colors()
#			elif selected_cells:
#				selected_cells.get_child(0).visible = false  # Hide the highlight of the selected cell
#				selected_cells = null

func _swap_colors():
	if is_hint_box_pressed:
		hint_box.color = Global.game_placed_digit_color
		hint_label.add_color_override("font_color", Color(1, 1, 1, 1))
	else:
		hint_box.color = Color(1, 1, 1, 1)
		hint_label.add_color_override("font_color", Global.game_placed_digit_color)

func _on_HintBox_pressed():
	SudokuSolver.solve(Global.puzzle, Global.filled_sudoku, "PlayerInput")
	yield(get_tree().create_timer(1.0), "timeout")

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
