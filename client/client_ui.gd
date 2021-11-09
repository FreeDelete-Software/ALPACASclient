# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Control

# Use ALPACAS connection by default
onready var _client = $ALPACAS
onready var _client_port = 4020

# Get UI elements
onready var _log_dest = $Panel/VBoxContainer/RichTextLabel
onready var _line_edit = $Panel/VBoxContainer/Send/LineEdit
onready var _host = $Panel/VBoxContainer/Connect/Host
onready var _client_mode = $Panel/VBoxContainer/Settings/Mode


func _ready():
	# Add menu options for the mode
	_client_mode.clear()
	_client_mode.add_item("ALPACAS")
	_client_mode.set_item_metadata(0, WebSocketPeer.WRITE_MODE_TEXT)
	_client_mode.add_item("Evennia")
	_client_mode.set_item_metadata(1, WebSocketPeer.WRITE_MODE_TEXT)


func _on_Mode_item_selected(_id):
	# Change the connection properties when they are chosen
	if _id == 0:
		_client = $ALPACAS
		_client_port = 4020
	elif _id == 1:
		_client = $Evennia
		_client_port = 4002


func _on_Send_pressed():
	_on_LineEdit_text_entered(_line_edit.text)


func _on_Connect_toggled( pressed ):
	if pressed:
		# Disable mode selection while connected
		_client_mode.disabled = true
		
		if _host.text != "":
			# Connect based on input text and hardcoded port.
			Utils._log(_log_dest, "Connecting to ALPACAS portal at IP: %s" % [_host.text])
			_client.connect_to_server(_host.text, _client_port)
			# This could probably use some better input validation.

	else:
		# Disconnect and enable mode selection when un-toggled.
		_client.disconnect_from_host()
		_client_mode.disabled = false


func _on_LineEdit_text_entered(_command):
	if _command== "":
		# Don't send blank lines
		return
	
	# Show command that was sent
	Utils._log(_log_dest, "Sending command: %s" % [_command])
	
	# Encode and send data.
	_client.send_data(Utils.encode_evennia(["text", [_command], {}]))
	
	# Clear out input field
	_line_edit.text = ""
