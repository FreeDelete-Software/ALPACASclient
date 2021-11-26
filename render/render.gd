extends Control

func _ready():
	print("Started scene rendering.")
	set_scene_background("default/white_1024x576.png")
	set_room_name("Not logged in!")


func set_scene_background(art_name):
	$Background.texture = load("res://art/%s" % art_name)


func set_room_name(name):
	$RoomName.text = name
