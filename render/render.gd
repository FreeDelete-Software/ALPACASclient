extends Control

signal send_command(cmd_string)

var default_bg = "default/empty_room1024x576.png"

onready var text_out = $Messages/Text
onready var _exits_container = $Exits
onready var _cmdgen = $CmdGen

var exit_scene = load("res://render/exit/exit.tscn")

func _ready():
	print("Started scene rendering.")
	logged_out_state()


func logged_out_state():
	unrender_all_scenery()
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
	
	# Remove everything in the current scene.
	unrender_all_scenery()
	
	# Set the room name
	set_room_name(room_dict["room_name"])
	
	# Set room background
	if room_dict["room_art"] == null:
		set_scene_background(default_bg)
	else:
		set_scene_background(room_dict["room_art"])


func render_exit(exit_dict):
	var this_exit = exit_scene.instance()
	this_exit.display_name = exit_dict["display_name"]
	this_exit.key_name = exit_dict["key_name"]
	this_exit.connect("left_clicked", self, "_on_exit_clicked")
	_exits_container.add_child(this_exit)


func unrender_all_scenery():
	for node in _exits_container.get_children():
		unrender(node)


func unrender(node):
	node.queue_free()


func _on_exit_clicked(exit_key):
	# No processing needed for exits. Its key is the command (assuming no dupes)
	_cmdgen._send_generated_command(exit_key)


func _on_Client_logged_in(is_logged_in):
	if is_logged_in:
		set_room_name("Logged in!")
		set_scene_background("default/empty_room1024x576.png")
		$Player.visible = true
	else:
		logged_out_state()


func _on_Client_render(args, kwargs):
	print(str(kwargs))
	for arg in args:
		if arg == "new_room":
			render_new_room(kwargs)
		if arg == "add_objects":
			for obj_dict in kwargs["obj_list"]:
				if obj_dict["obj_type"] == "exit":
					render_exit(obj_dict)
			


func _on_Client_text_msg(string_msg):
	text_out.add_text(string_msg)


func _on_CmdGen_send_generated_command(cmd_string):
	# Just passing this along for external use
	emit_signal("send_command", cmd_string)
