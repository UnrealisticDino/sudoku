extends Node2D

func _ready():
	var sudoku_node = get_node("Sudoku")
	sudoku_node.rect_min_size = Vector2(450, 450)  # Adjust the size as needed
	sudoku_node.columns = 9  # Ensure the GridContainer has 9 columns
