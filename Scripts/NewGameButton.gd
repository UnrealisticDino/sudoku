#NewGameButton
extends Button

func _ready():
	connect("pressed", self, "_on_NewGameButton_pressed")

func _on_NewGameButton_pressed():
	var difficulty_container = get_node("/root/SaveFiles/MenuPortrait/DifficultyContainer")
	if difficulty_container:
		difficulty_container.visible = true

	var newgameButton = get_node("/root/SaveFiles/MenuPortrait/VScrollBar/VBoxContainer/NewGameButton")
	if newgameButton:
		newgameButton.visible = false
		
	var placeHolder = get_node("/root/SaveFiles/MenuPortrait/VScrollBar/VBoxContainer/PlaceHolder")
	if placeHolder:
		placeHolder.visible = false
		
	var vboxContainer = get_node("/root/SaveFiles/MenuPortrait/VScrollBar/VBoxContainer")
	if vboxContainer:
		vboxContainer.visible = false
