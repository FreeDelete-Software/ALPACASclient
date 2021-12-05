extends Control

#
# inteactive.gd
# Indended to be extended by more specific scenery objects which
# get created as instances inside render.gd.
#

signal left_clicked(key_str)
signal right_clicked(key_str)

# Variable(s) intended to be set in an extended script
var default_texture = "default/error.png"

# Variables set at load time when instanced.
var display_name = "default"
var key_name = "default"
var sprite_file = "default"


func _ready():
	print("interactive.gd -- Scenery object added with key_name: %s" % key_name)
	$Texture/Label.text = display_name
	update_texture(sprite_file)


func update_texture(art_path):
	var full_path = "res://art/"
	if (Utils._art_exists(art_path)) == true:
		full_path += art_path
	else:
		full_path += default_texture
	$Texture.texture = load(full_path)
	var texture_size = $Texture.texture.get_size()
	$Texture.margin_left = -texture_size.x / 2
	$Texture.margin_right = -texture_size.x /2
	$Texture.margin_top = -texture_size.y / 2
	$Texture.margin_bottom = -texture_size.x /2


func _on_gui_input(event):
	if (event is InputEventMouseButton) and (event.pressed == true):
		# Get only the events we are looking for and emit results.
		print(str(event.button_index))
		if event.button_index == 1:
			print("interactive.gd -- Left-click registered on object.")
			emit_signal("left_clicked", key_name)
		elif event.button_index == 2:
			print("interactive.gd -- Right-click registered on object.")
			emit_signal("right_clicked", key_name)
