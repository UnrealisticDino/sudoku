# StartGame.gd
extends Button

func _ready():
	# Connect the "pressed" signal to the _on_StartGame_pressed function
	connect("pressed", self, "_on_StartGame_pressed")

func _on_StartGame_pressed():
	# Generate the puzzle using the function from the Global singleton
	Global.generate_puzzle_based_on_difficulty()
	
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Scenes/Sudoku.tscn")
