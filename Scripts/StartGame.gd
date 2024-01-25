extends Button

func _on_StartGame_button_up():
	var error = get_tree().change_scene("res://Scenes/StartGame.tscn")
	if error != OK:
		print("Failed to change scene: ", error)
