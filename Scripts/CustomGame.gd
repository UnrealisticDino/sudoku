#CustomGame.gd
extends Button

func _on_CustomGame_button_up():
	# Load the config file
	var config = ConfigFile.new()
	var config_path = "user://settings.cfg"
	var error = config.load(config_path)
	var generated_puzzle = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0], 
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0]
	]
	var grid_container_path = "../GridContainer"
	var grid_container = get_node_or_null(grid_container_path)
	GameState.puzzle = generated_puzzle

	GameState.save_button_name = "Custom Game"
	# Transition to the Sudoku scene
	GameState.transition_source = "CustomGame"
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
