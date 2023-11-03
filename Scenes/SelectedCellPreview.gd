#SelectedCellPreview
extends Panel

func _ready():
	# Assuming the game's background is stored as a global texture variable
	var game_background_texture = Global.game_background_texture

	# Create a new StyleBoxTexture for the panel
	var style = StyleBoxTexture.new()
	style.texture = game_background_texture

	# Apply the style to the panel
	self.set("custom_styles/panel", style)
