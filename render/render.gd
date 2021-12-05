extends Control

signal send_command(cmd_string)

var default_bg = "default/empty_room1024x576.png"

onready var text_out = $Messages/Text
onready var _exits_container = $Scenery/Exits
onready var _objects_container = $Scenery/Objects
onready var _cmdgen = $CmdGen

var _interactive = load("res://render/interactive/interactive.tscn")

func _ready():
	print("render.gd -- Started scene rendering.")
	logged_out_state()


func logged_out_state():
	unrender_all_scenery()
	set_scene_background("default/white_1024x576.png")
	set_room_name("Not logged in!")
	$Player.visible = false


func set_scene_background(art_path):
	if (Utils._art_exists(art_path)) == true:
		$Background.texture = load("res://art/%s" % art_path)
	else:
		# Use default bg image if FNF
		print("render.gd -- File not found: %s" % art_path)
		$Background.texture = load(default_bg)


func set_room_name(name):
	$RoomName.text = name


func render_new_room(room_dict):
	print("render.gd -- Rendering new room...")
	
	# Remove everything in the current scene.
	unrender_all_scenery()
	
	# Set the room name
	set_room_name(room_dict["room_name"])
	
	# Set room background
	if room_dict["room_art"] == null:
		set_scene_background(default_bg)
	else:
		set_scene_background(room_dict["room_art"])


func render_interactive(obj_dict):
	var this_obj = _interactive.instance()
	this_obj.display_name = obj_dict["display_name"]
	this_obj.key_name = obj_dict["key_name"]
	if obj_dict["obj_type"] == "exit":
		this_obj.default_texture = "default/door200.png"
		this_obj.connect("left_clicked", self, "_on_exit_clicked")
		Utils._anchor_node_center_bottom(this_obj)
		_exits_container.add_child(this_obj)


func unrender_all_scenery():
	for node in _exits_container.get_children():
		unrender(node)
	for node in _objects_container.get_children():
		unrender(node)


func unrender(node):
	node.queue_free()


func _on_exit_clicked(exit_key):
	# No processing needed for exits. Its key is the command (assuming no dupes)
	_cmdgen._send_generated_command(exit_key)


func _on_Client_logged_in(is_logged_in):
	if is_logged_in:
		set_room_name("Logged in!")
		$Player.visible = true
	else:
		logged_out_state()


func _on_Client_render(args, kwargs):
	print("render.gd -- Received kwargs: %s" % kwargs)
	for arg in args:
		if arg == "new_room":
			render_new_room(kwargs)
		if arg == "add_objects":
			for obj_dict in kwargs["obj_list"]:
				render_interactive(obj_dict)


func _on_Client_text_msg(string_msg):
	text_out.add_text(string_msg)


func _on_CmdGen_send_generated_command(cmd_string):
	# Just passing this along for external use
	emit_signal("send_command", cmd_string)
