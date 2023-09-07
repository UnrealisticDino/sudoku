# StartGame.gd
extends Button


func _ready():
	# Connect the "pressed" signal to the _on_StartGame_pressed function
	connect("pressed", self, "_on_StartGame_pressed")

func _on_StartGame_pressed():
	# Send the generated puzzle to PuzzleGenerator
	Global.send_grid(Global.filled_sudoku)
	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Scenes/Sudoku.tscn")
