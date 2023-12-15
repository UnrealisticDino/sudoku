#ButtonManager
extends Node

func add_load_button(vbox_container, difficulty):
	var current_datetime = OS.get_datetime_from_unix_time(OS.get_unix_time())
	var time_string = "%d-%02d-%02d %02d:%02d" % [current_datetime.year, current_datetime.month, current_datetime.day, current_datetime.hour, current_datetime.minute]
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/Old-Standard-TT/OldStandard-Regular.ttf")
	font.size = 50

	var load_button = Button.new()
	load_button.text = "%s - %s" % [difficulty, time_string]
	load_button.rect_min_size = Vector2(200, 50)
	load_button.add_font_override("font", font)
	vbox_container.add_child(load_button)
	
	# Create a delete button
	var delete_button = Button.new()
	delete_button.text = "Delete"
	delete_button.rect_min_size = Vector2(100, 50)
	delete_button.connect("pressed", self, "_on_delete_button_pressed", [vbox_container, difficulty, time_string, delete_button])
	vbox_container.add_child(delete_button)
	
	save_buttons_state(vbox_container)

func save_buttons_state(vbox_container):
	var buttons_data = []
	for child in vbox_container.get_children():
		if child is Button:
			buttons_data.append({"text": child.text})

	var file = File.new()
	if file.open("user://saved_buttons.dat", File.WRITE) == OK:
		file.store_var(buttons_data)
		file.close()

func load_buttons_state(vbox_container):
	var font = DynamicFont.new()
	font.font_data = load("res://Fonts/Old-Standard-TT/OldStandard-Regular.ttf")
	font.size = 50

	var file = File.new()
	if file.file_exists("user://saved_buttons.dat"):
		file.open("user://saved_buttons.dat", File.READ)
		var buttons_data = file.get_var()
		file.close()

		for button_data in buttons_data:
			# Create buttons only if they don't already exist
			if not button_exists(vbox_container, button_data["text"]):
				var load_button = Button.new()
				load_button.text = button_data["text"]
				load_button.rect_min_size = Vector2(200, 50)
				load_button.add_font_override("font", font)
				vbox_container.add_child(load_button)
				
				# Create a delete button for each save file
				var delete_button = Button.new()
				delete_button.text = "Delete"
				delete_button.rect_min_size = Vector2(100, 50)
				delete_button.connect("pressed", self, "_on_delete_button_pressed", [vbox_container, button_data["text"], delete_button])
				vbox_container.add_child(delete_button)

func button_exists(vbox_container, button_text):
	for child in vbox_container.get_children():
		if child is Button and child.text == button_text:
			return true
	return false

func _on_delete_button_pressed(container, save_file_name, delete_button):
	# Remove the save data file
	var save_path = "user://%s.dat" % save_file_name
	var file = File.new()
	
	if file.file_exists(save_path):
		if file.open(save_path, File.READ) == OK:
			file.close()
			file.remove(save_path)
	
	# Remove the associated buttons and the delete button itself
	for child in container.get_children():
		if child is Button:
			if child.text == save_file_name:
				container.remove_child(child)
	
	container.remove_child(delete_button)
	
	# Save the updated button state
	save_buttons_state(container)
