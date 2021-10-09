# This code was copied from the websocket_chat demo code provided by Godot
# under its MIT license terms. See godot.LICENSE.txt for the full license text.
# Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.
# Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).

# Modifications for the ALPACASclient project are BSD 3-Clause:
# Copyright (c) 2021, Michael J. Freidel
# See the LICENSE file for the full license text.

extends Control

onready var _client = $Client
onready var _log_dest = $Panel/VBoxContainer/RichTextLabel
onready var _line_edit = $Panel/VBoxContainer/Send/LineEdit
onready var _host = $Panel/VBoxContainer/Connect/Host
onready var _multiplayer = $Panel/VBoxContainer/Settings/Multiplayer
onready var _write_mode = $Panel/VBoxContainer/Settings/Mode
onready var _destination = $Panel/VBoxContainer/Settings/Destination

# ALPACAS
# Add var for Evennia connection node/script.
onready var _evennia = $Evennia
# ALPACAS

func _ready():
	_write_mode.clear()
	_write_mode.add_item("BINARY")
	_write_mode.set_item_metadata(0, WebSocketPeer.WRITE_MODE_BINARY)
	_write_mode.add_item("TEXT")
	_write_mode.set_item_metadata(1, WebSocketPeer.WRITE_MODE_TEXT)

	# ALPACAS -- Add Evennia option to Mode menu
	_write_mode.add_item("Evennia")
	_write_mode.set_item_metadata(2, WebSocketPeer.WRITE_MODE_TEXT)
	# ALPACAS

	_destination.add_item("Broadcast")
	_destination.set_item_metadata(0, 0)
	_destination.add_item("Last connected")
	_destination.set_item_metadata(1, 1)
	_destination.add_item("All But last connected")
	_destination.set_item_metadata(2, -1)
	_destination.select(0)


func _on_Mode_item_selected(_id):
	_client.set_write_mode(_write_mode.get_selected_metadata())


func _on_Send_pressed():
	if _line_edit.text == "":
		return

	var dest = _destination.get_selected_metadata()
	if dest > 0:
		dest = _client.last_connected_client
	elif dest < 0:
		dest = -_client.last_connected_client

# ALPACAS
	if _write_mode.get_selected_id() == 2:
		Utils._log(_log_dest, "Sending data %s to Evennia" % [_line_edit.text])
		_evennia.send_data(_line_edit.text)
	else:
		Utils._log(_log_dest, "Sending data %s to %s" % [_line_edit.text, dest])
		_client.send_data(_line_edit.text, dest)
# ALPACAS

	_line_edit.text = ""


func _on_Connect_toggled( pressed ):
	if pressed:
		var multiplayer = _multiplayer.pressed
		if multiplayer:
			_write_mode.disabled = true
		else:
			_destination.disabled = true
			_multiplayer.disabled = true
		if _host.text != "":
			# ALPACAS -- Add Evennia connect option
			if _write_mode.get_selected_id() == 2:
				Utils._log(_log_dest, "Connecting to Evennia server at IP: %s" % [_host.text])
				_evennia.connect_to_server(_host.text, "4002")
			else:
				Utils._log(_log_dest, "Connecting to Godot host: %s" % [_host.text])
				var supported_protocols = PoolStringArray(["my-protocol2", "my-protocol", "binary"])
				_client.connect_to_url(_host.text, supported_protocols, multiplayer)
			# ALPACAS
			
			
	else:
		_destination.disabled = false
		_write_mode.disabled = false
		_multiplayer.disabled = false
		_client.disconnect_from_host()
