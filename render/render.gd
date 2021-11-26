extends Control

func _ready():
	print("Started scene rendering.")
	logged_out_state()


func logged_out_state():
	set_scene_background("default/white_1024x576.png")
	set_room_name("Not logged in!")
	$Player.visible = false


func set_scene_background(art_name):
	$Background.texture = load("res://art/%s" % art_name)


func set_room_name(name):
	$RoomName.text = name


func _on_Client_logged_in(is_logged_in):
	if is_logged_in:
		set_room_name("Logged in!")
		set_scene_background("default/empty_room1024x576.png")
		$Player.visible = true
	else:
		logged_out_state()
