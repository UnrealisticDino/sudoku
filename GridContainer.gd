extends GridContainer

func _ready():
	for i in range(81):
		var cell = Button.new()
		add_child(cell)
	for button in get_children():
		button.rect_min_size = Vector2(50, 50)
