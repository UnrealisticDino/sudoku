#NewGameButton
extends Button

func _on_NewGameButton_button_up():
	print_tree()
	var difficulty_container = get_node("/root/SelectGame/MenuPortrait/DifficultyContainer")
	if difficulty_container:
		difficulty_container.visible = true

	var vboxContainer = get_node("/root/SelectGame/MenuPortrait/VScrollBar/VBoxContainer")
	if vboxContainer:
		vboxContainer.visible = false
