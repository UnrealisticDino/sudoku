extends ConfirmationDialog

func _ready():
	# Hide the OK and Cancel buttons
	get_ok().hide()
	get_cancel().hide()

	# Customize the style to effectively remove the title bar
	var style = StyleBoxEmpty.new()
	set("custom_styles/panel", style)
