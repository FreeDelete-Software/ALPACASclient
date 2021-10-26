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

onready var _log_dest = $Panel/VBoxContainer/RichTextLabel
onready var _line_edit = $Panel/VBoxContainer/Send/LineEdit
onready var _host = $Panel/VBoxContainer/Connect/Host
onready var _client_mode = $Panel/VBoxContainer/Settings/Mode


func _ready():
	_client_mode.clear()
	_client_mode.add_item("ALPACAS")
	_client_mode.set_item_metadata(0, WebSocketPeer.WRITE_MODE_TEXT)
	_client_mode.add_item("Evennia")
	_client_mode.set_item_metadata(1, WebSocketPeer.WRITE_MODE_TEXT)


func _on_Mode_item_selected(_id):
	if _id == 0:
		_client = $ALPACAS
		_client_port = 4020
	elif _id == 1:
		_client = $Evennia
		_client_port = 4002
	_client.set_write_mode(_client_mode.get_selected_metadata())


func _on_Send_pressed():
	if _line_edit.text == "":
		return

	Utils._log(_log_dest, "Sending command: %s" % [_line_edit.text])
	_client.send_data(Utils.encode_evennia(["text", [_line_edit.text], {}]))


func _on_Connect_toggled( pressed ):
	if pressed:
		_client_mode.disabled = true
		if _host.text != "":
			Utils._log(_log_dest, "Connecting to ALPACAS portal at IP: %s" % [_host.text])
			_client.connect_to_server(_host.text, _client_port)

	else:
		_client_mode.disabled = false
		_client.disconnect_from_host()
