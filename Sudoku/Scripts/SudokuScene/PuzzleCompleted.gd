#PuzzleCompleted
extends Button

func _on_PuzzleCompleted_button_up():
	get_tree().change_scene("res://Scenes/StartGame.tscn")
