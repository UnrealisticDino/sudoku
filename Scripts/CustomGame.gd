#CustomGame.gd
extends Button

func _on_CustomGame_button_up():
	# Load the config file
	var config = ConfigFile.new()
	var config_path = "user://settings.cfg"
	var error = config.load(config_path)
	Global.puzzle = [[0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0]]

	# Transition to the sudoku.tscn scene
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
