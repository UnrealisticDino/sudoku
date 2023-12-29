extends Button

func _on_OptionsMenu_button_up():
	var error = get_tree().change_scene("res://Scenes/Settings.tscn")
	if error != OK:
		print("Failed to change scene: ", error)
