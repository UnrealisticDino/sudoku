extends GridContainer
var PuzzleGenerator = preload("res://PuzzleGenerator.tscn")

func _ready():
	var puzzle_generator = PuzzleGenerator.instance()
	add_child(puzzle_generator)
	var puzzle = puzzle_generator.generate_sudoku()
	for i in range(81):
		var cell = Button.new()
		cell.text = str(puzzle[i/9][i%9])  # Set the button text to the corresponding puzzle number
		add_child(cell)
	for child in get_children():
		if child is Control:
			child.rect_min_size = Vector2(50, 50)

