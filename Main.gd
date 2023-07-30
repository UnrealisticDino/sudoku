extends Control

func _ready():
	var puzzle_generator = get_node("PuzzleGeneratorParent/PuzzleGenerator")
	Global.completed_sudoku = puzzle_generator.generate_sudoku()
