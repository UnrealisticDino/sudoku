# GoToMainMenu
extends Button

func _ready():
	# Connect the "pressed" signal to the _on_StartButton_pressed function
	connect("pressed", self, "_on_StartButton_pressed")

func _on_StartButton_pressed():
	# Change the scene to GameScene.tscn when the button is pressed
	get_tree().change_scene("res://Scenes/Settings.tscn")
