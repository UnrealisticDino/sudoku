# PlayerInput.gd
extends Control

onready var Global = get_node("/root/Global")
var SudokuSolver = preload("res://Scenes/SudokuSolver.gd").new()
var hint_box

func _ready():
	hint_box = ColorRect.new()
	hint_box.rect_min_size = Vector2(100, 40)  # Set the size of the box
	hint_box.color = Global.game_placed_digit_color  # Set the color from Global.gd
	add_child(hint_box)
	
	var hint_label = Label.new()
	hint_label.text = "Hint"
	hint_label.rect_min_size = Vector2(100, 40)
	hint_box.add_child(hint_label)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		print("Mouse clicked at: ", mouse_pos)  # Debugging
		if hint_box.rect_global_position.x < mouse_pos.x and mouse_pos.x < hint_box.rect_global_position.x + hint_box.rect_min_size.x:
			if hint_box.rect_global_position.y < mouse_pos.y and mouse_pos.y < hint_box.rect_global_position.y + hint_box.rect_min_size.y:
				print("Hint box clicked")  # Debugging
				hint_box.color = Global.selected_cell_color  # Change color when pressed
				_on_HintBox_pressed()

func _on_HintBox_pressed():
	print("Hint box pressed function triggered")  # Debugging
	SudokuSolver.solve(Global.puzzle, Global.filled_sudoku, "PlayerInput")
	hint_box.color = Global.game_placed_digit_color  # Reset color after action
