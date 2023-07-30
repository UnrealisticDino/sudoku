# Global.gd
extends Node

var difficulty = "easy"  # Default value
var completed_sudoku = []  # Default value

func _ready():
	print("Global.gd is ready")
	print("Initial completed_sudoku: ", completed_sudoku)
