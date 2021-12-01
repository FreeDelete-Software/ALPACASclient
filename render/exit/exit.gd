extends Control

signal left_clicked(key_str)
signal right_clicked(key_str)

var display_name = ""
var key_name = ""

func _ready():
	$Texture/Label.text = display_name


func _on_Panel_gui_input(event):
	if (event is InputEventMouseButton) and (event.pressed == true):
		print(str(event.button_index))
		if event.button_index == 1:
			print("Click registered at Exit node")
			emit_signal("left_clicked", key_name)
		elif event.button_index == 2:
			emit_signal("right_clicked", key_name)
