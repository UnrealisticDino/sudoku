extends Node2D

func _ready():
	var sudoku_node = get_node("Sudoku")
	sudoku_node.rect_min_size = Vector2(450, 450)  # Adjust the size as needed
	sudoku_node.columns = 9  # Ensure the GridContainer has 9 columns

	# Get the puzzle from Global.completed_sudoku
	var puzzle = Global.completed_sudoku

	# Populate the Sudoku grid with the puzzle
	populate_sudoku_grid(puzzle)

func populate_sudoku_grid(puzzle):
	# This is a placeholder function. You need to implement this function to populate the Sudoku grid with the puzzle data.
	pass
