# StartGame.gd
extends Button

# Create a variable to hold the preloaded PuzzleGenerator script
var PuzzleGeneratorScript = preload("res://Scenes/PuzzleGenerator.gd")

# Create a variable to hold the PuzzleGenerator instance
var puzzle_generator

func _ready():
	# Connect the "pressed" signal to the _on_StartGame_pressed function
	connect("pressed", self, "_on_StartGame_pressed")
	
	# Instantiate the PuzzleGenerator class
	puzzle_generator = PuzzleGeneratorScript.new()
	add_child(puzzle_generator)

func _on_StartGame_pressed():
	print(OS.get_environment("PATH"))
	
	# Generate a new puzzle using PuzzleGenerator
	puzzle_generator.generate_sudoku()
	
	# Fetch the generated grid from PuzzleGenerator's game_board
	var generated_grid = puzzle_generator.game_board
	
	# Send the generated puzzle to Global (or wherever you handle the game state)
	Global.fetch_grid(generated_grid)
	
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Scenes/Sudoku.tscn")
