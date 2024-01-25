#MainMenu.gd
extends Panel

# In your main menu script
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed in main menu")
		get_tree().quit()
