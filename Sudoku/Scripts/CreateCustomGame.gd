#CreateCustomGame
extends Button

func _on_CreateCustomGame_button_up():
	var difficulty = "Custom Game"
	var grandparent_node = get_parent().get_parent()
	var draw_grid = grandparent_node.get_node("DrawGrid")
	var current_datetime = OS.get_datetime_from_unix_time(OS.get_unix_time())
	var time_string = "%02d:%02d" % [current_datetime.hour, current_datetime.minute]
	var button_text = "%s - %s" % [difficulty, time_string]

	# Call a function in the script attached to the DrawGrid node
	draw_grid.save_state()

	# Access the puzzle variable directly
	GameState.puzzle = draw_grid.puzzle
	print("Puzzle data: ", GameState.puzzle)

	# Call the add_load_button function in ButtonManager singleton
	var button_name = (button_text)
	GameState.save_button_name = button_name

	# Transition to the Sudoku scene
	get_tree().change_scene("res://Sudoku/Scenes/Sudoku.tscn")
