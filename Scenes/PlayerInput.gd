# PlayerInput.gd
extends Control

onready var Global = get_node("/root/Global")
var SudokuSolver = preload("res://Scenes/SudokuSolver.gd").new()
var hint_box
var hint_box_outline
var hint_label
var is_hint_box_pressed = false

func _ready():
	add_child(SudokuSolver)
	# Create the outline for the hint box
	hint_box_outline = ColorRect.new()
	hint_box_outline.rect_min_size = Vector2(104, 44)  # Slightly larger than the hint_box
	hint_box_outline.color = Global.grid_lines_color  # Set the outline color
	add_child(hint_box_outline)

	# Create the hint box
	hint_box = ColorRect.new()
	hint_box.rect_min_size = Vector2(100, 40)  # Set the size of the box
	hint_box.color = Color(1, 1, 1, 1)  # Set the color to white
	hint_box.rect_position = Vector2(2, 2)  # Position it within the outline
	hint_box_outline.add_child(hint_box)  # Add hint_box as a child of the outline
	
	# Create the label
	hint_label = Label.new()
	hint_label.text = "Hint"
	hint_label.rect_min_size = Vector2(100, 40)
	hint_label.align = Label.ALIGN_CENTER  # Center align horizontally
	hint_label.valign = Label.VALIGN_CENTER  # Center align vertically
	hint_label.add_color_override("font_color", Global.game_placed_digit_color)  # Set the text color to green
	hint_box.add_child(hint_label)

func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var mouse_pos = event.position
		var is_mouse_over_hint_box = hint_box_outline.rect_global_position.x < mouse_pos.x and mouse_pos.x < hint_box_outline.rect_global_position.x + hint_box_outline.rect_min_size.x and hint_box_outline.rect_global_position.y < mouse_pos.y and mouse_pos.y < hint_box_outline.rect_global_position.y + hint_box_outline.rect_min_size.y

		if event is InputEventMouseButton:
			if event.pressed and is_mouse_over_hint_box:
				is_hint_box_pressed = true
				_swap_colors()
				_on_HintBox_pressed()
			elif not event.pressed and is_hint_box_pressed:
				is_hint_box_pressed = false
				if is_mouse_over_hint_box:
					_swap_colors()
		elif event is InputEventMouseMotion:
			if is_hint_box_pressed and not is_mouse_over_hint_box:
				is_hint_box_pressed = false
				_swap_colors()

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
