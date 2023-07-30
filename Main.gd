extends Control

var completed_sudoku  # This will store the completed Sudoku puzzle

func _ready():
	var puzzle_generator = get_node("PuzzleGeneratorParent/PuzzleGenerator")
	completed_sudoku = puzzle_generator.generate_sudoku()
