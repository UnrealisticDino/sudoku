extends GridContainer
var PuzzleCreator = preload("res://PuzzleCreator.gd")  # Load the PuzzleCreator script

func _ready():
	var puzzle_creator = PuzzleCreator.new()  # Create a new instance of PuzzleCreator
	get_parent().add_child(puzzle_creator)  # Add the PuzzleCreator instance to the parent node
	var puzzle = puzzle_creator.get_puzzle()  # Get the puzzle from PuzzleCreator
	for i in range(81):
		var cell = Button.new()
		cell.text = str(puzzle[i/9][i%9])  # Set the button text to the corresponding puzzle number
		add_child(cell)
	for child in get_children():
		if child is Control:
			child.rect_min_size = Vector2(50, 50)
