extends Control

var default_bg = "default/empty_room1024x576.png"

onready var text_out = $Messages/Text

func _ready():
	print("Started scene rendering.")
	logged_out_state()


func logged_out_state():
	set_scene_background("default/white_1024x576.png")
	set_room_name("Not logged in!")
	$Player.visible = false


func set_scene_background(art_name):
	var res_path = "res://art/%s" % art_name
	
	var checkFile = File.new()
	if checkFile.file_exists(res_path):
		$Background.texture = load(res_path)
	else:
		# Use default bg image if FNF
		print("File not found: %s" % res_path)
		$Background.texture = load(default_bg)


func set_room_name(name):
	$RoomName.text = name


func render_new_room(room_dict):
	print("Rendering new room...")
	print(str(room_dict))
	
	set_room_name(room_dict["room_name"])
	if room_dict["room_art"] == null:
		set_scene_background(default_bg)
	else:
		set_scene_background(room_dict["room_art"])


func _on_Client_logged_in(is_logged_in):
	if is_logged_in:
		set_room_name("Logged in!")
		set_scene_background("default/empty_room1024x576.png")
		$Player.visible = true
	else:
		logged_out_state()


func _on_Client_render(args, kwargs):
	var art_file
	for arg in args:
		if arg == "new_room":
			render_new_room(kwargs)
		if arg == "add_obj":
			print("Objects rendering skipped...")
			


func _on_Client_text_msg(string_msg):
	text_out.add_text(string_msg)
